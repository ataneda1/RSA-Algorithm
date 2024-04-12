#
#Program Name:gcd.s
#Author:Kbrom Ghirmai
#Date:3/27/24
#Purpose: Perform exponentiation
#

.text
.global main

main:

 #Push to stack
  SUB sp, sp, #4
  STR lr, [sp, #0]

 #Prompt and read input number base number
  LDR r0, =Prompt1
  BL printf
  LDR r0, =format1
  LDR r1, =Input1
  BL scanf

 #Store base number
  LDR r4,=Input1
  LDR r4,[r4]

 #Prompt and read input exponent value
  LDR r0, =Prompt2
  BL printf
  LDR r0, =format2
  LDR r1, =Input2
  BL scanf

 #Save second exponent in safe register
 LDR r5,=Input2
 LDR r5,[r5]

 #Implement pow function and move result to r0
  BL pow
  MOV r0,r6
 
 #Print result
  MOV r1,r0
  LDR r0, =Output
  BL printf 

 #Pop to Stack
  LDR lr, [sp, #0]
  ADD sp, sp, #4
  MOV pc, lr
  
.data
Prompt1: .asciz "Enter the base number: "
format1: .asciz "%d"
Input1: .word 0
Prompt2: .asciz "Enter the exponent value for the calculation: "
format2: .asciz "%d"
Input2: .word 0
Output: .asciz "The exponentiation result is: %d\n " 
