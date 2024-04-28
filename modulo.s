#
# Program Name:modulo.s
# Author: Anthony Taneda
# Date:4/9/2024
# Purpose: Prompts user for integers m, n and prints m (mod n) to test the modulo function
# Inputs: N/A
# Outputs: N/A
#

.text
.global main

main:
    # Save return
    SUB sp, sp, #4
    STR lr, [sp, #0]

    # Prompt for any integer m
    LDR r0, =Prompt1
    BL printf
    LDR r0, =format1
    LDR r1, =Input1
    BL scanf

    #Prompt for any integer n
    LDR r0, =Prompt2
    BL printf
    LDR r0, =format2
    LDR r1, =Input2
    BL scanf

    # Save inputs in safe registers
    LDR r4,=Input1 // m in r4
    LDR r4,[r4]
    LDR r5,=Input2 // n in r5
    LDR r5,[r5]

    # Call modulo function to get m (mod n) and print result
    BL modulo // outputs m (mod n) to r3
    MOV r1,r3 // move result to r1
    LDR r0, =Output
    BL printf 

    # Return
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr
  
.data
    Prompt1: .asciz "Enter the first number for the modulo calculation: "
    format1: .asciz "%d"
    Input1: .word 0,0
    Prompt2: .asciz "Enter the second output for the modulo calculation: "
    format2: .asciz "%d"
    Input2: .word 0,0
    Output: .asciz "The remainder of dividing those two values is: %d\n " 
