#
#Program Name:mainProg.s
#Author:Kbrom Ghirmai
#Date:4/12/2024
#Purpose: Execute all needed functions for RSA algorithm implementation using RsaLib functions
#

.text
.global main

main:

#Push to stack
 SUB sp, sp, #4
 STR lr, [sp, #0]

#main loop where user is prompted for values
StartMain:

 #Prompt user to input p and read/store the value
 LDR r0, =promptP
 BL printf
 LDR r0, =formatP
 LDR r1, =numP
 BL scanf
 LDR r4, =numP
 LDR r4, [r4]
 CMP r4,#50
 BGT ErrMsgP1
  B checkP

 ErrMsgP1:
 #Print Error message and ask user to choose valid P value
  LDR r0,=ErrorP1
  BL printf
  B StartMain

#Check if P is valid
 checkP:
 BL mainProg
 CMP r9,#1
 BEQ tryQ
  B ErrMsgP2

 ErrMsgP2:
 #Print Error Message
  LDR r0,=ErrorP2
  BL printf
  B StartMain

 tryQ:
  #Prompt user to input q and read/store that value and check if its valid
  LDR r0,=promptQ
  BL printf
  LDR r0,=formatQ
  LDR r1,=numQ
  BL scanf
  #Put q in r4 to check if prime
  LDR r4,=numQ
  LDR r4,[r4]
  CMP r4,#50
  BGT ErrMsgQ1
   B CheckQ

 ErrMsgQ1:
   #Print error message 
    LDR r0,=ErrorQ1
    BL printf
    B StartMain
 
 CheckQ:
   BL mainProg
   CMP r9,#1
   BNE ErrMsgQ2
    B checkPubExp

 ErrMsgQ2:
 LDR r0,=ErrorQ2
 BL printf
 B tryQ

 checkPubExp:
  
 #Prompt user to input public key exponent 
  LDR r0,=promptE
  BL printf
  LDR r0,=formatE
  LDR r1,=numE
  BL scanf
  LDR r6,=numE
  LDR r6,[r6]
     
 #Get input P and Q values into r4 and r5 before calling CPubExp function
 LDR r4,=numP
 LDR r4,[r4]
 LDR r5,=numQ
 LDR r5,[r5]
 MOV r10,#0

 #Implement CPubExp to check its valid
  BL CPubExp
  CMP r10,#1
  BEQ PromptRsaAlg
   B checkPubExp

 PromptRsaAlg:
 #Prompt user to choose if they want to Encrypt or Decrypt a messge
  LDR r0,=promptAlg
  BL printf
  LDR r0,=formatAlg
  LDR r1,=numAlg
  BL scanf

 #Take user input and implement encryption or decryption algorithm
  LDR r3,=numAlg
  LDR r3,[r3]
  CMP r3,#3
  BEQ StartEncryptAlg
   B StartDecryptAlg

 StartEncryptAlg:
 #Get values in proper register for encryption
  LDR r4,=numP
  LDR r4,[r4]
  LDR r5,=numQ
  LDR r5,[r5]
  LDR r8,=numE
  LDR r8,[r8]
  MOV r10,#0
  MUL r10,r4,r5
  BL Encrypt
  B EndMain

 StartDecryptAlg:
#Promt for d value and get p,q,e values from prior input to calculate private exponent and move it to r11 and put n in r10
 #Prompt user for integer x needed in formula for calculating private key exponent
  LDR r0, =promptD
  BL printf
  #Read and store input integer x
  LDR r0, =formatD
  LDR r1, =numD
  BL scanf
  LDR r4,=numP
  LDR r4,[r4]
  LDR r5,=numQ
  LDR r5,[r5]
  LDR r7,=numD
  LDR r7,[r7]
  LDR r8,=numE
  LDR r8,[r8] 
  BL CPrivExp
  #correct d is in r7
  MOV r10,#0
  LDR r4,=numP
  LDR r4,[r4]
  LDR r5,=numQ
  LDR r5,[r5]
  MUL r10,r4,r5
  BL Decrypt
  B EndMain
 
EndMain:
#Pop stack
 LDR lr, [sp, #0]
 ADD sp, sp, #4
 MOV pc, lr

.data
promptP: .asciz "Enter a postive prime number that is less than 50 for (P): "
promptQ: .asciz "Enter a positive prime number that is less than 50 for (Q): "
promptE: .asciz "Please enter a positve value that is greater than 1 for the public key exponent (e): "
promptD: .asciz "Please choose a small positive number for the private key exponent(d): "
promptAlg: .asciz "To encrypt a message press 3 and to decrypt a message press 4: "
formatP: .asciz "%d"
formatQ: .asciz "%d"
formatE: .asciz "%d"
formatD:.asciz "%d"
formatAlg: .asciz "%d"
numP: .word 0
numQ: .word 0
numE: .word 0
numD: .word 0
numAlg: .word 0
ErrorP1: .asciz "Sorry the P value you input is greater than 50 so it is invalid, please input a valid P value\n"
ErrorP2: .asciz "Sorry the P value you input is not a prime number so it is invalid, please input a valid P value\n"
ErrorQ1: .asciz "Sorry the Q value you input is greater than 50 so it is invalid, please input a valid P value\n"
ErrorQ2: .asciz "Sorry the Q value you input is not a prime number so it is invalid, please input a valid Q value\n"
test: .asciz "Looks like the loops work, but unfortunately the decrypt algorithm isn't ready for use\n"

