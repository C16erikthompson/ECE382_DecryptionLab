;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studios
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file

;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory
            .retain
            .retainrefs
encrypted:		.byte		0x35,0xdf,0x00,0xca,0x5d,0x9e,0x3d,0xdb,0x12,0xca,0x5d,0x9e,0x32,0xc8,0x16,0xcc,0x12,0xd9,0x16,0x90,0x53,0xf8,0x01,0xd7,0x16,0xd0,0x17,0xd2,0x0a,0x90,0x53,0xf9,0x1c,0xd1,0x17,0x90,0x53,0xf9,0x1c,0xd1,0x17,0x90
key:			.byte		0x73, 0xbe
decrypted:		.equ		0x200
counter:		.equ		0x002
                                    		; Override ELF conditional linking
                                            ; and retain current section
                               				; Additionally retain any sections
                                            ; that have references to current
                                            ; section
;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;-------------------------------------------------------------------------------
                                            ; Main loop here
;-------------------------------------------------------------------------------

            ;
            ; load registers with necessary info for decryptMessage here
            ;
            mov.w	#key,			r4		;moves the used key to r4
            mov.w	#key,			r12		;stores the original location of the key for reseting
            mov.w	#encrypted,		r5		;moves location of encrypted message to r5
            mov.w	r5,				r9
            sub		r4,				r9		;message length in r9
			mov		#decrypted,		r6
			mov.b	#counter,				r7
            call    #decryptMessage

forever:    jmp     forever

;-------------------------------------------------------------------------------
                                            ; Subroutines
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;Subroutine Name: decryptMessage
;Author:
;Function: Decrypts a string of bytes and stores the result in memory.  Accepts
;           the address of the encrypted message, address of the key, and address
;           of the decrypted message (pass-by-reference).  Accepts the length of
;           the message by value.  Uses the decryptCharacter subroutine to decrypt
;           each byte of the message.  Stores theresults to the decrypted message
;           location.
;Inputs:r5,r8,r7,r6,r4
;Outputs:r6
;Registers destroyed:r6
;-------------------------------------------------------------------------------

decryptMessage:
			mov.b		@r5+,				r8		;move first part of encrypted message to r8, point at next part
			call		#decryptCharacter				;decrypts
			dec		r7						;checks to see if at end of key
			cmp		#0,				r7
			jz		resetKey
contDecrypt:
			mov.b		r8,				0(r6)		;moves decrypted value to RAM
			inc		r6						;points at next location in RAM
			decd    	r9
			tst		r9						;checks if at end of message3
			jz		forever
			jmp		decryptMessage
        		ret
resetKey:
			mov		#counter,			r7		;resets the key back to the first byte
			mov.w	r12,					r4
			clrz
			jmp		contDecrypt
;-------------------------------------------------------------------------------
;Subroutine Name: decryptCharacter
;Author:
;Function: Decrypts a byte of data by XORing it with a key byte.  Returns the
;           decrypted byte in the same register the encrypted byte was passed in.
;           Expects both the encrypted data and key to be passed by value.
;Inputs:r4,r8
;Outputs:r8
;Registers destroyed:r8
;-------------------------------------------------------------------------------

decryptCharacter:
			xor.b		@r4+,		r8				;xors r4 with r8, stores in r8, increments to next part of r4
            ret

;-------------------------------------------------------------------------------
;           Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect    .stack

;-------------------------------------------------------------------------------
;           Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
