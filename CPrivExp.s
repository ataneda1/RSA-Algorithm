#
#Program Name:CPrivExp.s
#Author:Anthony Taneda
#Date:3/27/24
#Purpose: Test the RsaLib function that calcualtes the private exponent d
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

 #Pick public Exp for test 
  MOV r8,#5

 #Prompt for private exponent d and read value
  LDR r0,=promptD
  BL printf
  LDR r0,=formatD
  LDR r1,=inputD
  BL scanf

 #Put input d in r7 and implement CPrivExp
  LDR r7,=inputD
  LDR r7,[r7]  
  BL CPrivExp
 
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
promptD: .asciz "Please input a private key exponent d greater than 0: "
formatD: .asciz "%d"
inputD: .word 0
