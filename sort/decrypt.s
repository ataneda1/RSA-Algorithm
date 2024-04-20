.text
.global decrypt

decrypt:
#
# Purpose: Performs the mathematical function associated with decryption
# Inputs:
#   r0: Any integer c
#   r1: Any integer d
#   r2: Any integer n
# Outputs:
#   r0: m = c^d (mod n)
#
    # Save return
    SUB sp, sp, #8
    STR lr, [sp, #0]
    STR r4, [sp, #4]

    # Temporarily store n
    MOV r4, r2

    # Calculate c^d
    // r0 and r1 already contain c and d respectively
    BL pow

    # Calculate c^d (mod n)
    // r0 already contains c^d
    MOV r1, r4 // n
    BL mod

    # Return
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    ADD sp, sp, #8
    MOV pc, lr

.data
    
