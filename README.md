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

###Required Functionality
Read an encrypted message and key in from ROM.  Use subroutines to decrypt this message and stor the results in RAM starting at 0x200



###B Functionality
Perform the same function as the required functionality but with a key of arbitrary length




###A Functionality
Discover a key to decrypt the given message
