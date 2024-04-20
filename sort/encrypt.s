.text
.global encrypt

encrypt:
#
# Purpose: Performs the mathematical function associated with encryption
# Inputs:
#   r0: Any integer m
#   r1: Any integer e
#   r2: Any integer n
# Outputs:
#   r0: c = m^e (mod n)
#
    # Save return
    SUB sp, sp, #8
    STR lr, [sp, #0]
    STR r4, [sp, #4]

    # Temporarily store n
    MOV r4, r2

    # Calculate m^e
    // r0 and r1 already contain m and e respectively
    BL pow

    # Calculate m^e (mod n)
    // r0 already contains m^e
    MOV r1, r4 // n
    BL mod

    # Return
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    ADD sp, sp, #8
    MOV pc, lr

.data
    
