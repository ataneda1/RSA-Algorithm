#
# Program Name: CPrivExp.s
# Author:Anthony Taneda
# Date: 3/27/24
# Purpose: Prompts user for integers p, q and prints d where de = 1 (mod phi(n)) to test the CPrivExp function
#   where e = and phi(n) = (p-1)*(q-1)
# Inputs: N/A
# Outputs: N/A
#

.text
.global main

main:
    # Save return
    SUB sp, sp, #4
    STR lr, [sp, #0]

    # Prompt for input p
    LDR r0, =PromptP
    BL printf
    LDR r0, =formatP
    LDR r1, =numP
    BL scanf

    # Prompt and read input q
    LDR r0, =PromptQ
    BL printf
    LDR r0, =formatQ
    LDR r1, =numQ
    BL scanf

    # Prompt for private exponent e and read value
    LDR r0, =promptE
    BL printf
    LDR r0, =formatE
    LDR r1, =inputE
    BL scanf
    
    # Move inputs to safe registers
    LDR r4, =numP // p to r4
    LDR r4, [r4]
    LDR r5, =numQ // q to r5
    LDR r5, [r5]
    LDR r8, =inputE // e to r8
    LDR r8, [r8]  

    # Call private exponent function and print output
    BL CPrivExp
    MOV r1, r7
    LDR r0, =output
    BL printf
 
    # Return
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
    promptE: .asciz "Please input a public key exponent e greater than 0: "
    formatE: .asciz "%d"
    inputE: .word 0
    output: .asciz "The corresponding private key exponent is %d\n"
