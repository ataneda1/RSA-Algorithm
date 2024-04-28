.text
.global main

Inverse:
#
# Purpose: Calculates the modular inverse d of e (mod phi(n)) by finding a d such that
#   de = 1 (mod phi(n)) or de-1 = 0 (mod phi(n))
#
# Inputs:
#   r0: Any integer e
#   r1: Any integer phi(n)
#
# Outputs:
#   r0: d, the modular inverse of e in mod phi(n)
#

    # Save return
    SUB sp, sp, #16
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r6, [sp, #12]    

    # Temporarily save variables
    MOV r4, r0 // e
    MOV r5, r1 // phi(n)
    MOV r6, #0 // loop counter d

    # Main Loop
    InverseLoop:
      # Prepare d for comparison
      MUL r0, r4, r6 // de
      SUB r0, r0, #1 // de - 1
      ADD r0, r0, r5 // de - 1 + phi(n) still congruent to de - 1 (mod phi(n))

      # Determine if current d is the modular inverse, using mod function
      // r0 already contains de-1
      MOV r1, r5 // phi(n)
      BL mod
      CMP r0, #0
      BEQ EndInverse // current d is the modular inverse
      
      # Current d was not the modular inverse, look at next d
      ADD r6, r6, #1
      B InverseLoop

    # Return
    EndInverse:
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    LDR r6, [sp, #12]
    ADD sp, sp, #16
    MOV pc, lr

.data
