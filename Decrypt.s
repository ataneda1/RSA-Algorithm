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
 BL Decrypt

#Pop from OS Stack
 LDR lr, [sp, #0]
 ADD sp, sp, #4
 MOV pc, lr

.data
