#
# Program Name: 2
# Author: Anthony Taneda
# Date: 2024 April 14
# Purpose: Calculates the nth number in the Fibonacci sequence
# Functions:
#   Fibonacci: Recursively determines the nth Fibonacci number
#

.text
.global main

main:
    # Save return to os on stack
    SUB sp, sp, #4
    STR lr, [sp, #0]

    # Prompt for a number
    LDR r0, =prompt
    BL printf
    LDR r0, =format
    LDR r1, =input
    BL scanf

    # Load input and check if non-negative
    LDR r0, =input
    LDR r0, [r0]
    CMP r0, #0
    BLT Error

    # Call Fibonacci function
    BL Fibonacci

    # Print output
    MOV r1, r0 // Move output to correct register for printing
    LDR r0, =output
    BL printf

    B Exit

    # Input was invalid
    Error:
      LDR r0, =errorMessage
      BL printf

    # Return to the OS
    Exit:
      LDR lr, [sp, #0]
      ADD sp, sp, #4
      MOV pc, lr

.data
    prompt: .asciz "Enter a number: "
    format: .asciz "%d"
    input: .word 0
    output: .asciz "The corresponding Fibonacci number is %d\n"
    errorMessage: .asciz "Input should be a non-negative integer\n"

.text
Fibonacci:
#
# Purpose: Recursively calculates the nth Fibonacci number with formula
#   F(n) = F(n-1) + F(n-2) with F(1) = 1 and F(0) = 0
# Inputs:
#   r0: n
# Outputs:
#   r0: F(n), i.e., the nth Fibonacci number
#

    # Save return
    SUB sp, sp, #12
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]

    # Initialize variables
    MOV r4, r0 // move n to r4
    MOV r5, #0 // initialize the sum to 0

    # Check if n = 0 or n = 1 applies (base cases)
    CMP r4, #0
    BEQ Zero
    CMP r4, #1
    BEQ One
    B Recursion // not a base case, apply recursion

    # n = 0, return 0
    Zero:
      # F(0) = 0
      MOV r0, #0      

      # Exit current recursion loop
      B Return
      
    # n = 1, return 1
    One:
      # F(1) = 1
      MOV r0, #1

      # Exit current recursion loop
      B Return

    # n > 1, return F(n-1) + F(n-2)
    Recursion:
      // Add F(n-1) to the output
      SUB r0, r4, #1 // (n-1)
      BL Fibonacci // F(n-1)
      ADD r5, r0, r5 // output = F(n-1)

      // Add F(n-2) to the output
      SUB r0, r4, #2 // (n-2)
      BL Fibonacci // F(n-2)
      ADD r5, r0, r5 // output = F(n-1) + F(n-2)

      # Move output to r0 and exit current recursion loop
      MOV r0, r5
      B Return

    # Return
    Return:
      LDR lr, [sp]
      LDR r4, [sp, #4]
      LDR r5, [sp, #8]
      ADD sp, sp, #12
      MOV pc, lr
.data 
