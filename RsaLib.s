#
#Program name: RsaLib.s
#Author: Kbrom Ghirmai
#Date: 03/23/2024
#Purpose: To hold a library of functions needed to implement the RSA algorithm
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
#
# Purpose: Function to calculate the remainder of dividing two values
#
# Register Dictionary
# r4 - Any integer m
# r5 - Any integer n
# r0 - The remainder m (mod n)
# r3 - Duplicate of m (mod n)
#
.global modulo
.text

modulo:
    # Save return
    SUB sp, sp, #4
    STR lr, [sp, #0]

    # Move m and n to appropriate registers 
    MOV r0, r4 // m
    MOV r1, r5 // n
    
    # Perform integer division
    BL __aeabi_idiv // (m // n)

    # Recover remainder
    MUL r0, r0, r5 // (m // n) * n
    SUB r0, r4, r0 // m - (m // n) * n = m % n

    # Duplicate output to r3
    MOV r3, r0

    # Return
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
#
# Purpose: Calculates the modular inverse d of e in modulo phi(n), i.e., de = 1 (mod phi(n))
#
# Register Dictionary
#   r4 - Holds the value of p that the user chooses
#   r5 - Holds the value of user input q
#   r6 - Holds the totient phi(n) that is calculated using input p and q
#   r7 - Outputs private exponent d
#   r8 - Holds user input public exponent value e
#   r9 - Temporary variable for determining if d is valid
#
    # Save return
    SUB sp, sp, #8
    STR lr, [sp, #0]
    STR r9, [sp, #4]

    # Calculate totient and store it in r6
    MOV r6, #0 // Initialize r6 to 0
    SUB r4, r4, #1 // r4 = p - 1
    SUB r5, r5, #1 // r5 = q - 1
    MUL r6, r4, r5 // r6 = phi(n) = (p - 1)(q - 1)

    # Find the modular inverse d 
    MOV r7, #0 // Initialize d to 0
    B PrivExpLoop // Main loop to check if d is valid
    
    PrivExpLoop:
      # Prepare d for comparison
      MUL r9, r7, r8 // de
      SUB r9, r9, #1 // de - 1
      ADD r9, r9, r6 // de - 1 + phi(n) = de - 1 (mod phi(n))

      # Call modulo function to calculate de - 1 mod (phi (n))
      MOV r4, r9 // r4 = de-1
      MOV r5, r6 // r5 = phi(n)
      BL modulo // r0 = de - 1 mod (phi (n))

      # Determine if current d is modular inverse
      CMP r0, #0
      BEQ EndPrivExp // de - 1 = 0 (mod phi(n))  =>  d is the modular inverse

      # Current d was not modular inverse, look at next d
      ADD r7, r7, #1 // d = d + 1
      B PrivExpLoop
    
    # Return
    EndPrivExp:
      LDR lr, [sp, #0]
      LDR r9, [sp, #4]
      ADD sp, sp, #8
      MOV pc, lr

.data
    privErr: .asciz "That d value is invalid because it's  greater the totient(%d), please input a value that is less than that..."
    promptd: .asciz "Please input a private key exponent d value: "
    formatd: .asciz "%d"
    numd: .word 0
    privExpErr2: .asciz "That d value is invalid please try inputting another d value..."
    testval: .asciz "Congrats is the valid d value\n"
    #End of CPrivExp

#Function Name:Encrypt
#Purpose: Check if input is an alphabetic character and return logical variable as an indicator(1=true,0=false)
.global Encrypt
.text

#Register Dictionary
#r2-register that holds the ascii value current byte from input message
#r9-safe register that holds the input message 
#r4-holds values that are passed into exponentiation (pow) function and modulo function
#r5-holds values that are passed into exponentiation (pow) function and modulo function
#r8-holds the value public exponent

Encrypt:

#Push to stack
 SUB sp, sp, #4
 STR lr, [sp, #0]

 #Open the file
 LDR r0, =filename  // Load the address of filename into r0
 LDR r1,=filemode     
 BL fopen            // Call open function
 MOV r11,r0

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
#Calculate and print Encrypted Ciphertext Value (c) for each byte of message
#c=(m^e) mod n
 MOV r4,r2
 MOV r5,r8
 BL pow
 MOV r4,r6
 MOV r5,r10
 BL modulo
 MOV r7,r3 
 
 #Write to file 
 MOV r0,r11
 MOV r11,r0   
 LDR r2,=Msg
 MOV r2,r7
 LDR r1,=Output
 BL fprintf
 B StartAsciiLoop

EndAsciiLoop:
 MOV r0,r11
 BL fclose 
#Pop to Stack
 LDR lr, [sp, #0]
 ADD sp, sp, #4
 MOV pc, lr
 
.data
prompt1:  .asciz "Please type in the message that you want to encrypt: "
format1:  .asciz "%s"
Msg:      .space 100
Output: .asciz " %d "
filemode: .asciz "w"
filename:   .asciz  "Encrypted.txt"
#End of Encrypt 


#Function Name:Decrypt
#Purpose: Take an input encrypted numerical ciphertext value and use binary exponentiation algorithm to get m (plaintext character

.global Decrypt
.text

#Register Dictionary
#r4-Used to hold dividend prior to calling modulo function
#r5-Used to hold divisor prior to calling modulo function
#r6-Holds input encrypted ciphertext value (c) 
#r7-Holds encrypted private exponent d that is manipulate in binary exponentiation
#r9-Holds resulting plaintext ascii value that the decrypted character (m) is equal to
#r10-Holds value of n(n=p*q) which is needed for finding the plaintext value m
#r11-Holds initial private exponent value d (just so original d value is preserved) 

Decrypt:
#Push to stack
 SUB sp, sp, #4
 STR lr, [sp, #0]

#Prompt user to input encrypted ciphertext value (c) for decryption
 LDR r0,=promptC
 BL printf
 LDR r0,=formatC
 LDR r1,=InputC
 BL scanf

#Put ciphertext value c in r6 for decryption alg
 LDR r6,=InputC
 LDR r6,[r6] 
 
#Initialize values for loop
 MOV r9,#1
 MOV r11,r7
 MOV r4,r6
 MOV r5,r10
 BL modulo
 MOV r6,r0 

StartBinExpLoop:
 CMP r7,#0
 BEQ EndBinExpLoop
  B checkOdd

 checkOdd:
  MOV r3,r7
  AND r0,r3,#1
  CMP r0,#0
  BEQ isEven
   B isOdd
  
 isOdd:
 #result=(result*c)%n
  MOV r2,#1
  MOV r2,r9
  MUL r2,r9,r6
  MOV r4,r2
  MOV r5,r10
  BL modulo
  MOV r9,r0
  #d=d/2
  MOV r3,r7
  ASR r0,r3,#1
  MOV r7,r0
  #c=(c*c)%n
  MOV r2,#1
  MUL r2,r6,r6
  MOV r4,r2
  MOV r5,r10
  BL modulo
  MOV r6,r0
  B StartBinExpLoop
 
 isEven:
 #d=d/2
  MOV r3,r7
  ASR r0,r3,#1
  MOV r7,r0
 #c=(c*c)%n
  MOV r2,#1
  MUL r2,r6,r6
  MOV r4,r2
  MOV r5,r10
  BL modulo
  MOV r6,r0
  B StartBinExpLoop

#Print resulting decrypted character
EndBinExpLoop:
 MOV r1,r9
 LDR r0,=outputC
 BL printf
 B ContRQuit
 
 #Prompt user to input next ciphertex value for decryption or quit the program
 ContRQuit:
 LDR r0,=promptCR
 BL printf
 LDR r0,=formatCR
 LDR r1,=InputCR
 BL scanf
 LDR r1,=InputCR
 LDR r1,[r1]
 CMP r1,#-1
 BNE ContDecry
   B EndDecryptionAlg
 
#Intialize required values before restarting decrpytion if user decides to continue decryption
 ContDecry:
 LDR r6,=InputCR
 LDR r6,[r6]
 MOV r9,#1
 MOV r4,r6
 MOV r5,r10
 BL modulo
 MOV r6,r0
 MOV r7,r11
 B StartBinExpLoop
 
EndDecryptionAlg:
#Pop Stack
 LDR lr, [sp, #0]
 ADD sp, sp, #4
 MOV pc, lr
      
.data
promptC: .asciz "Input the ciphertext(c) value that you want decrypted: "
formatC: .asciz "%d"
InputC: .word 0
outputC: .asciz "%c\n"
promptCR: .asciz "Input next ciphertext(c) value to decrypt or enter -1 to quit: "
formatCR: .asciz "%d"
InputCR: .word 0   
#End of Decrypt
