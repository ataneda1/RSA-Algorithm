.text
.global pow

pow:
#
# Purpose: Performs the mathematical modulo function
# Inputs:
#   r0: Any integer x
#   r1: Any integer y
# Outputs:
#   r0: The exponent x^y
#

    # Save return
    SUB sp, sp, #4
    STR lr, [sp, #0]

    # Temporarily store x in r2
    MOV r2, r0

    # Check for special cases
    CMP r1, #0
    BEQ powZero // zeroth power
    BLT powNeg // negative powers
    B powLoop // normal powers

    # Normal powers
    powLoop:
      # Check if loop should exit, i.e., y == 1
      CMP r1, #1
      BEQ powEnd

      # Increment product
      MUL r0, r0, r2 // prod = prod * x

      # Decrement power
      SUB r1, r1, #1

      # Proceed to next iteration
      B powLoop

    # Zeroth power
    powZero:
      MOV r0, #1 // default output for invalid inputs
      B powEnd

    # Negative Powers (is this even necessary)
    powNeg:
      MOV r0, #1
      B powEnd

    # Return
    powEnd:
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr

.data
