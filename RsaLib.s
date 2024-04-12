#
#Program name: RsaLib.s
#Author: Anthony Taneda,Kbrom Ghirmai,Muhammad Qazi
#Date: 03/23/2024
#Purpose: To hold a library of conversion programs
#Functions gcd,pow,modulo,cpubexp,cprivexp,encrypt,decrypt
#

#Function Name:gcd
#Purpose: Find the greatest common divisor for two input values
.global gcd
.text

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
 LDR r0,=error1
 BL printf
 B EndLoop1

 CheckE:
 CMP r6,r5
 BGT ErrMsg2
  B CheckCPrime

 ErrMsg2:
 #Print Error Message
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
 LDR r0,=error3
 BL printf
 B EndLoop1
 
 validE:
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

#Push to stack
 SUB sp, sp, #4
 STR lr, [sp, #0]



