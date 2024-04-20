.text
.global mod

mod:
#
# Purpose: Performs the mathematical modulo function
# Inputs:
#   r0: Any integer m
#   r1: Any integer n
# Outputs:
#   r0: The modulus m mod n
#

    # Save return
    SUB sp, sp, #12
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]

    # Store m and n in temporary registers
    MOV r4, r0 // m
    MOV r5, r1 // n

    # Perform integer division
    BL __aeabi_idiv // (m // n)

    # Recover remainder
    MUL r0, r0, r5 // (m // n) * n
    SUB r0, r4, r5 // m - (m // n) * n = m % n

    # Return
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    ADD sp, sp, #12
    MOV pc, lr

.data
