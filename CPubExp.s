#
#Program Name: CPubExp.s
#Author:Kbrom Ghirmai,Anthony Taneda,Muhammad Qazi
#Date: 04/04/2024
#Purpose: Implement CPubExp function to check if CPubExp function worked in the beginning
#

.text
.global main

main:

#Push to stack
 SUB sp, sp, #4
 STR lr, [sp, #0]

#Prompt and read input p value
 LDR r0, =prompt1
 BL printf
 LDR r0, =format1
 LDR r1, =pval
 BL scanf
#Save p value in safe register
 LDR r4,=pval
 LDR r4,[r4]

#Prompt and read q value
 LDR r0, =prompt2
 BL printf
 LDR r0, =format2
 LDR r1, =qval
 BL scanf
#Save q value in safe register
 LDR r5,=qval
 LDR r5,[r5]

InputPublicExp:
#Prompt for public exponent
 LDR r0, =prompt3
 BL printf
#Read input value
 LDR r0, =format3
 LDR r1, =pubExp
 BL scanf
#Save input public exponent to r4
 LDR r6,=pubExp
 LDR r6,[r6]
 
#Implement cpuexp function
 MOV r10,#0
 BL CPubExp
 CMP r10,#1
 BEQ EndPubExpChk
  B InputPublicExp

EndPubExpChk:
#Pop to Stack
 LDR lr, [sp, #0]
 ADD sp, sp, #4
 MOV pc, lr
  
.data
prompt1: .asciz "Enter a prime number for p that is greater than 0 and less than 50: "
prompt2: .asciz "Enter a prime number for q that is greater than 0 and less than 50: "
prompt3: .asciz "Enter a public key exponent value that's greater than 1: "
format1: .asciz "%d" 
format2: .asciz "%d"
format3: .asciz "%d"
pval: .word 0
qval: .word 0
pubExp: .word 0

