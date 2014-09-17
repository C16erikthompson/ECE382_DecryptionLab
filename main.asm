;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file

;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory
            .retain
            .retainrefs
encrypted:		.byte		0xef,0xc3,0xc2,0xcb,0xde,0xcd,0xd8,0xd9,0xc0,0xcd,0xd8,0xc5,0xc3,0xc2,0xdf,0x8d,0x8c,0x8c,0xf5,0xc3,0xd9,0x8c,0xc8,0xc9,0xcf,0xde,0xd5,0xdc,0xd8,0xc9,0xc8,0x8c,0xd8,0xc4,0xc9,0x8c,0xe9,0xef,0xe9,0x9f,0x94,0x9e,0x8c,0xc4,0xc5,0xc8,0xc8,0xc9,0xc2,0x8c,0xc1,0xc9,0xdf,0xdf,0xcd,0xcb,0xc9,0x8c,0xcd,0xc2,0xc8,0x8c,0xcd,0xcf,0xc4,0xc5,0xc9,0xda,0xc9,0xc8,0x8c,0xde,0xc9,0xdd,0xd9,0xc5,0xde,0xc9,0xc8,0x8c,0xca,0xd9,0xc2,0xcf,0xd8,0xc5,0xc3,0xc2,0xcd,0xc0,0xc5,0xd8,0xd5,0x8f
key:			.byte		0xac
decrypted:		.equ		0x200
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
            mov.w	#key,			r4
            mov.w	#encrypted,		r5
            mov.w	r5,				r9
            sub		r4,				r9		;message length in r9
			mov		#decrypted,		r6
			mov.b	#0,				r7
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
;Inputs:
;Outputs:
;Registers destroyed:
;-------------------------------------------------------------------------------

decryptMessage:
			mov.b	@r5+,				r8
			call	#decryptCharacter
			mov.b	r8,					0(r6)
			inc		r6
			jmp		decryptMessage

            ret

;-------------------------------------------------------------------------------
;Subroutine Name: decryptCharacter
;Author:
;Function: Decrypts a byte of data by XORing it with a key byte.  Returns the
;           decrypted byte in the same register the encrypted byte was passed in.
;           Expects both the encrypted data and key to be passed by value.
;Inputs:
;Outputs:
;Registers destroyed:
;-------------------------------------------------------------------------------

decryptCharacter:
			xor.b		@r4,		r8
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
