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
