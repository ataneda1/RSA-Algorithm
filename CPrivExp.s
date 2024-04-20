#
#Program Name:gcd.s
#Author:Kbrom Ghirmai
#Date:3/27/24
#Purpose: Find the greatest common divisor between two inputs
#

.text
.global main

main:

 #Push to stack
  SUB sp, sp, #4
  STR lr, [sp, #0]

 #Prompt and read input p
  LDR r0, =PromptP
  BL printf
  LDR r0, =formatP
  LDR r1, =numP
  BL scanf
 #Store p in r4
  LDR r4,=numP
  LDR r4,[r4]

 #Prompt and read input q
  LDR r0, =PromptQ
  BL printf
  LDR r0, =formatQ
  LDR r1, =numQ
  BL scanf
 #Save q in safe register
 LDR r5,=numQ
 LDR r5,[r5]

 #Calculate Totient and put it in r6 for use in CPrivExp
 MOV r3,#0
 SUB r3,r4,#1
 MOV r2,#0
 SUB r2,r5,#1
 MOV r9,#0
 MUL r9,r2,r3
 MOV r6,r9

 #Pick public Exp for test 
 MOV r8,#3

 #Pick integer x value for test
 MOV r7,#2
 
 #Implement gcd function
  BL CPrivExp
 
 #Print result
  MOV r1,r0
  LDR r0, =Output
  BL printf 

 #Pop to Stack
  LDR lr, [sp, #0]
  ADD sp, sp, #4
  MOV pc, lr
  
.data
PromptP:.asciz "Input a positive prime number that is less than 50 for (p): "
formatP:.asciz "%d"
numP: .word 0
PromptQ: .asciz "Input a positive prime number that is less than 50 for (q): "
formatQ: .asciz "%d"
numQ: .word 0
Output: .asciz "Your private exponent based on all the inputs is: %d\n"

