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

When running the program with the provided encrypted message:
0xef,0xc3,0xc2,0xcb,0xde,0xcd,0xd8,0xd9,0xc0,0xcd,0xd8,0xc5,0xc3,0xc2,0xdf,0x8d,0x8c,0x8c,0xf5,0xc3,0xd9,0x8c,0xc8,0xc9,0xcf,0xde,0xd5,0xdc,0xd8,0xc9,0xc8,0x8c,0xd8,0xc4,0xc9,0x8c,0xe9,0xef,0xe9,0x9f,0x94,0x9e,0x8c,0xc4,0xc5,0xc8,0xc8,0xc9,0xc2,0x8c,0xc1,0xc9,0xdf,0xdf,0xcd,0xcb,0xc9,0x8c,0xcd,0xc2,0xc8,0x8c,0xcd,0xcf,0xc4,0xc5,0xc9,0xda,0xc9,0xc8,0x8c,0xde,0xc9,0xdd,0xd9,0xc5,0xde,0xc9,0xc8,0x8c,0xca,0xd9,0xc2,0xcf,0xd8,0xc5,0xc3,0xc2,0xcd,0xc0,0xc5,0xd8,0xd5,0x8f

and a key of 0xac,the following message is shown:

![](http://i47.photobucket.com/albums/f189/erik_thompson2/Lab2Requiredpic_zpsbe11871d.png?raw=true)

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
When running the program with the provided encrypted message:
0xf8,0xb7,0x46,0x8c,0xb2,0x46,0xdf,0xac,0x42,0xcb,0xba,0x03,0xc7,0xba,0x5a,0x8c,0xb3,0x46,0xc2,0xb8,0x57,0xc4,0xff,0x4a,0xdf,0xff,0x12,0x9a,0xff,0x41,0xc5,0xab,0x50,0x82,0xff,0x03,0xe5,0xab,0x03,0xc3,0xb1,0x4f,0xd5,0xff,0x40,0xc3,0xb1,0x57,0xcd,0xb6,0x4d,0xdf,0xff,0x4f,0xc9,0xab,0x57,0xc9,0xad,0x50,0x80,0xff,0x53,0xc9,0xad,0x4a,0xc3,0xbb,0x50,0x80,0xff,0x42,0xc2,0xbb,0x03,0xdf,0xaf,0x42,0xcf,0xba,0x50,0x8f

and a key of 0xacdf3, the following message is shown:

![](http://i47.photobucket.com/albums/f189/erik_thompson2/Lab2B_zpsd9c8e4ce.png?raw=true)


###A Functionality
Discover a key to decrypt the given message

The following image details my process and the solution:

![](http://i47.photobucket.com/albums/f189/erik_thompson2/20140917_091353_zpsmd8xleuv.jpg?raw=true)

When the discovered key (0x73be) is plugged in, the following message is produced

![](http://i47.photobucket.com/albums/f189/erik_thompson2/Lab2A_zpsba4c5f55.png?raw=true)

#Bugs
	-If no key is provided, program would crash
	-If the message is extremely long, there may not be enough space in RAM to display it
#Documentation
None
