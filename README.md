ECE382_DecryptionLab
====================

Decrypts an input from ROM

#Overview

##Basic Idea
In this lab, a program was created that decrypts a message using the simple "xor" metho.  The "xor method works as follows:
1. The message to be encrypted is xored with a key to produce the encrypted message
2. The message is sent to the recipient
3. The recipient xors the encrypted message with the same key that was used to encrypt it, resulting in the decrypted/original message

##In This Lab
The purpose of this lab is as follows: The utilization of subroutines to decrypt a given message

###Prelab

![](http://i47.photobucket.com/albums/f189/erik_thompson2/20140917_091353_zpsmd8xleuv.jpg?raw=true)


###Required Functionality
Read an encrypted message and key in from ROM.  Use subroutines to decrypt this message and stor the results in RAM starting at 0x200

To achieve required functionality, I created two subroutines titled decryotMessage and decryptCharacte which pass the decrypted message to ROM and decrypt a given character respectively.  decryptMessage calls upon decryptCharacter to complete its task.

####decrpytMessage
```
decryptMessage:
			mov.b	@r5+,				r8      ;moves character to be decrypted into r8, increments to nect character in encrypted message
			call	#decryptCharacter   ;calls decryptCharacter
			mov.b	r8,					0(r6)   ;moves decrypted character into spot in RAM
			inc		r6                  ;moves to next spot for decryption
			decd  r9                  ;checks to see if at the end of the message
			tst		r9
			jz		forever
			jmp		decryptMessage
            ret
```
####decryptCharacter

```
decryptCharacter:
			xor.b		@r4,		r8        ;xors the key with the given character
            ret
```
###B Functionality
Perform the same function as the required functionality but with a key of arbitrary length
additions to decrypt message: (1)a counter that cycles through the given key. implemented through: (1) initializing a register as a counter (2) creating two loops (2a) one that resets the key (2b) one that continues the message with the new key location

####decryptMessage
```
decryptMessage:
			mov.b	@r5+,				r8
			call	#decryptCharacter
			dec		r7                    ;key counter
			cmp		#0,					r7
			jz		resetKey
contDecrypt:
			mov.b	r8,					0(r6)
			inc		r6
			decd    r9
			tst		r9
			jz		forever
			jmp		decryptMessage
            ret
resetKey:                         ;resets to initial value in ROM of key
			mov		#counter,					r7
			mov.w	r12,				r4
			clrz
			jmp		contDecrypt
```
####decryptCharacter
```
decryptCharacter:
			xor.b		@r4+,		r8        ;addition of postincrement of key
            ret
```
###A Functionality
Discover a key to decrypt the given message
