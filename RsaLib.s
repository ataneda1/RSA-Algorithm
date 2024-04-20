#
#Program name: RsaLib.s
#Author: Kbrom Ghirmai
#Date: 03/23/2024
#Purpose: To hold a library of conversion programs
#Functions:mainProg, gcd,pow,modulo,cpubexp,cprivexp,encrypt,decrypt
#

.global mainProg
.text

#Function Name:mainProg
#Purpose: check if user value is prime (for checking p and q)

#Register Dictionary
#r4-input value that will be checked
#r5-Loop Limit for inner check prime loop
#r6-Loop counter for check prime loop
#r7- current divisor value for checking if prime
#r8-boolean for result of check prime
#r9-boolean to hold result of check prime for main function
 
mainProg:
#Push to stack
 SUB sp, sp, #4
 STR lr, [sp, #0]

#Sentinel loop for checking if P and Q are prime numbers
startCheckPrimePQ:
 
 #get number of iterations loop must run through (n/2 - 2)
  MOV r0, r4
  MOV r1, #2
  BL __aeabi_idiv
  SUB r0, r0, #2
     
  MOV r5, r0        //loop limit
  MOV r6, #0        //loop counter
  MOV r7, #2        //current divisor
  MOV r8, #1        //boolean result

StartCheckPrimeLoop:

     #check if end conditon is met (loop limit reached)
     CMP r6, r5
     BGE EndCheckPrimeLoop

     #check if input value is divisible by current divisor
     MOV r0, r4
     MOV r1, r7
     BL __aeabi_idiv
     MOV r2,r0
     MOV r3,r4
     MUL r2,r1,r2
     SUB r3,r3,r2
     #Move remainder into r0 and check if it is 0
     MOV r0,r3
     CMP r0, #0
     MOVEQ r8, #0
     BEQ EndCheckPrimeLoop

     #increment loop counter and current divisor and run checkprime loop again
     ADD r6, r6, #1
     ADD r7, r7, #1
     B StartCheckPrimeLoop

    EndCheckPrimeLoop:
       
    #Check for result,print the result and then return to the main(sentinel) startloop
    MOV r1, r4
    CMP r8, #1
    BEQ ResultPrime
     B ResultNotPrime

    ResultPrime:
     MOV r9,#1
     B endCheckPrimePQ

    ResultNotPrime:
     MOV r9,#0
     B endCheckPrimePQ
 
endCheckPrimePQ:
#Pop to Stack
 LDR lr, [sp, #0]
 ADD sp, sp, #4
 MOV pc, lr

.data
#End of checkPQ

#Function Name:gcd
#Purpose: Find the greatest common divisor for two input values
.global gcd
.text

#Register Dictionary
#r4-Input value of first number 
#r5-input value of second number to do gcd comparison
#r1-Holds resulting value of the gcd

gcd:

 #Push to stack
  SUB sp, sp, #4
  STR lr, [sp, #0]
 
 #Caluclate greatest common divisor of two inputs (r4,r5)
 StartLoop:
  CMP r4,r5
  BEQ end
    #if the two input values aren't equal
    B divisor
  divisor:
  CMP r4,r5
  BLT subLow
   SUB r4,r4,r5
   B StartLoop
 subLow:
  CMP r4,r5
  BGT divisor
   SUB r5,r5,r4
   B StartLoop
 end:
 MOV r1,r4

 #Pop to Stack
  LDR lr, [sp, #0]
  ADD sp, sp, #4
  MOV pc, lr

.data
#End of gcd


#Function Name:pow
#Author: Kbrom Ghirmai and Muhammad Qazi
#Purpose: Function to perform exponentiation
.global pow
.text

pow: 
 #Register Dictionary
 #r4-base value
 #r5-exponent value
 #r6-exponent operation result storage
 #r7-Loop counter

#make sure r6 is clear initially
MOV r6,#1  
#Set loop limit equal to the exponent value
  MOV r7, #0
  MOV r7, r5

   startLoop:
     CMP r7, #0 
     BEQ endLoop
       B multiplyExponent

     multiplyExponent:
      MUL r6, r4, r6
      SUB r7, r7, #1
      B startLoop
   endLoop:
    # The final value of, x^y for example, stores into r6.
      
.data
#End of pow function


#Function Name:modulo
#Purpose: Function to calculate the remainder of dividing two values
.global modulo
.text

modulo:
#Push to stack
 SUB sp, sp, #4
 STR lr, [sp, #0]

#Get the modulus of two values
#Get remainder of dividing to numbers
 MOV r0,r4
 MOV r1,r5
 BL __aeabi_idiv
 MOV r0,r3

#Pop to Stack
 LDR lr, [sp, #0]
 ADD sp, sp, #4
 MOV pc, lr

.data
#End of modulo


#Function Name:cpubexp
#Purpose: Take user input public key exponent and confirm it is valid
.global CPubExp
.text

#Register dictionary
#r4-Input value P
#r5-Input value Q
#r10-boolean for result of checking input e

CPubExp:

#Push to OS stack
 SUB sp, sp, #4
 STR lr, [sp, #0]

#Calculate totient using input p and q value
 SUB r4,r4,#1
 SUB r5,r5,#1
 MUL r5,r4,r5

#Start main loop to check input public key exponent value
StartLoop1:

#check if e is valid
 CMP r6,#1
 BLE ErrMsg1
  B CheckE

 ErrMsg1:
 #Print Error Msg
 MOV r10,#0
 LDR r0,=error1
 BL printf
 B EndLoop1

 CheckE:
 CMP r6,r5
 BGT ErrMsg2
  B CheckCPrime

 ErrMsg2:
 #Print Error Message
  MOV r10,#0
  LDR r0,=error2
  BL printf
  B EndLoop1

 CheckCPrime:
 MOV r4,r6
 BL gcd
 CMP r1,#1
 BEQ validE
  #if e is not coprime with totient
  B ErrMsg3

 ErrMsg3:
 MOV r10,#0
 LDR r0,=error3
 BL printf
 B EndLoop1
 
 validE:
 MOV r10,#1
 MOV r8,r6
 LDR r0,=output1
 BL printf
 B EndLoop1
 
EndLoop1:
#Pop to Stack
 LDR lr, [sp, #0]
 ADD sp, sp, #4
 MOV pc, lr

.data
error1: .asciz "Your input public exponent must be greater than 1\n"
error2: .asciz "Your input is greater than the totient, please input a different valid value\n"
error3: .asciz "Your input public key exponent is not coprime to the totient\n"
output1: .asciz "That is a valid public key exponent\n"
#End of CPubExp function

#Function Name:CPrivExp
#Purpose: Check if input is an alphabetic character and return logical variable as an indicator(1=true,0=false)

.global CPrivExp
.text

CPrivExp:
#register dictionary
#r4-Hold the value of p that the user chooses
#r5-holds the value of user input q
#r6-holds the totient that is calculated using input p and q
#r7-Hold user input integer for x in the eq for calculating d
#r8-Hold user input public exponent value

#Push to stack
 SUB sp, sp, #4
 STR lr, [sp, #0]

#Calculate totient and store it in r6
 MOV r6,#0
 SUB r4,r4,#1
 SUB r5,r5,#1
 MUL r6,r4,r5

#Calculate private key exponent (d)
#Simplified eq for calculating d (d=1+x*phi(n))/e
 MOV r10,#0
 MUL r10,r6,r7
 ADD r10,r10,#1
 MOV r0,r10
 MOV r1,r8
 BL __aeabi_idiv
 #resulting priv exp will be in r0 

#Pop from OS Stack
 LDR lr, [sp, #0]
 ADD sp, sp, #4
 MOV pc, lr

.data
#End of CPrivExp

#Function Name:Encrypt
#Purpose: Check if input is an alphabetic character and return logical variable as an indicator(1=true,0=false)
.global Encrypt
.text

Encrypt:

#Push to stack
 SUB sp, sp, #4
 STR lr, [sp, #0]
 
#Prompt for input string and read the string
 LDR r0,=prompt1
 BL printf
 LDR r0,=format1
 LDR r1,=Msg
 BL scanf

#Get Ascii value of character in string
 LDR r1,=Msg

#Intialize r4 as counter of each character/byte in input string
 MOV r2,#0
 MOV r9,r1

StartAsciiLoop:
 LDRB r2,[r9],#1
 CMP r2,#0
 BNE PrintAscii
  B EndAsciiLoop
   
PrintAscii:
#Print Ascii Value
 MOV r4,r2
 MOV r5,r8
 BL pow
 MOV r4,r6
 MOV r5,r10
 BL modulo
 MOV r1,r3
 LDR r0,=output
 BL printf 
 B StartAsciiLoop

EndAsciiLoop:
#Pop to Stack
 LDR lr, [sp, #0]
 ADD sp, sp, #4
 MOV pc, lr
 
.data
prompt1: .asciz "Please type in the message that you want to encrypt: "
format1: .asciz "%s"
Msg: .space 100                 
output: .asciz "%d "

#End of Encrypt 

#Function Name:Decrypt
#Purpose: Check if input is an alphabetic character and return logical variable as an indicator(1=true,0=false)

.global Decrypt
.text

Decrypt:
#Push to stack
 SUB sp, sp, #4
 STR lr, [sp, #0]

#Prompt user to input valid ascii value for a character
 LDR r0,=promptA
 BL printf
 LDR r0,=formatA
 LDR r1,=InputAscii
 BL scanf

#Convert number to ascii string
 LDR r4,=InputAscii
 LDR r4,[r4]
 MOV r5,r11
 BL pow
 MOV r4,r6
 MOV r5,r10
 BL modulo
 MOV r1,r3
 LDR r0,=outputA
 BL printf

#Pop Stack
 LDR lr, [sp, #0]
 ADD sp, sp, #4
 MOV pc, lr
      
.data
promptA: .asciz "Input the ascii value of a character from A-Z or a-z: "
formatA: .asciz "%d"
InputAscii: .word 0
outputA: .asciz "Your equivalent character is: %c\n"
#End of Decrypt














