#
#Program Name: Encrypt.s
#Author:Kbrom Ghirmai
#Date: 04//13/2024
#Purpose: Test functionality Encrypt function from RsaLib
#

.text
.global main
main:

#Push to stack record
 SUB sp, sp, #4
 STR lr, [sp, #0]

#Put test values for d,c and n and call Encrypt Function from RsaLib
MOV r7,#29
MOV r10,#91
MOV r8,#5
BL Encrypt

#Pop from stack record
 LDR lr, [sp, #0]
 ADD sp,sp,#4
 MOV pc,lr

.data
