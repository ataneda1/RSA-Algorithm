#
#Program Name: Encrypt.s
#Author:Kbrom Ghirmai
#Date: 04//13/2024
#Purpose: Test Encrypt function from RsaLib
#

.text
.global main
main:

#Push to stack record
 SUB sp, sp, #4
 STR lr, [sp, #0]

#Call Encrypt Function from RsaLib
BL Encrypt

#Pop from stack record
 LDR lr, [sp, #0]
 ADD sp,sp,#4
 MOV pc,lr

.data
