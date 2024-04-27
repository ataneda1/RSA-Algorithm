#
#
#Program Name: Decrypt.s
#Author: Kbrom Ghirmai
#Date: 4/18/2024
#Purpose: Test decrypt function from RSALib
#

.text
.global main

main:

#Push to OS stack
 SUB sp, sp, #4
 STR lr, [sp, #0]

#Implement decrypt method
 MOV r7,#29
 MOV r10,#91
 BL Decrypt

#Pop from OS Stack
 LDR lr, [sp, #0]
 ADD sp, sp, #4
 MOV pc, lr

.data
