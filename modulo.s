#
#Program Name:modulo.s
#Author:Kbrom Ghirmai
#Date:4/9/2024
#Purpose: Find the remainder of dividing the two inputs using modulo function
#

.text
.global main

main:

 #Push to stack
  SUB sp, sp, #4
  STR lr, [sp, #0]

 #Prompt and read first input number
  LDR r0, =Prompt1
  BL printf
  LDR r0, =format1
  LDR r1, =Input1
  BL scanf

 #Store first input number
  LDR r4,=Input1
  LDR r4,[r4]

 #Prompt and read second input number
  LDR r0, =Prompt2
  BL printf
  LDR r0, =format2
  LDR r1, =Input2
  BL scanf

 #Save second input in safe register
 LDR r5,=Input2
 LDR r5,[r5]

 #Implement gcd function
  BL modulo
 
 #Print result
  MOV r1,r0
  LDR r0, =Output
  BL printf 

 #Pop to Stack
  LDR lr, [sp, #0]
  ADD sp, sp, #4
  MOV pc, lr
  
.data
Prompt1: .asciz "Enter the first number for the modulo calculation: "
format1: .asciz "%d"
Input1: .word 0
Prompt2: .asciz "Enter the second output for the modulo calculation: "
format2: .asciz "%d"
Input2: .word 0
Output: .asciz "The greatest common divisor is: %d\n " 
