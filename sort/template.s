.text
.global main

main:
    # Save return
    SUB sp, sp, #8
    STR lr, [sp, #0]
    STR r4, [sp, #4]

    # Startup prompt
    Start:
      # Prompt for user input
      LDR r0, =startPrompt
      BL printf
      LDR r0, =startFormat
      LDR r1, =startInput
      BL scanf

      # Store user input in r4 and branch to appropriate subprogram
      LDR r4, =startInput
      LDR r4, [r4]

      # Exit
      CMP r4, #-1
      BEQ Exit

      # Generate public/private keys
      CMP r4, #1
      //BL ???      

      # Encrypt a message
      CMP r4, #2
      //BL ???

      # Decrypt a message
      CMP r4, #3
      //BL ???      

      B Exit

    # Return
    Exit:
      # Print exit message
      LDR r0, =exitMessage
      BL printf

      # Fix stack
      LDR lr, [sp, #0]
      LDR r4, [sp, #4]
      ADD sp, sp, #8
      MOV pc, lr

.data
    startPrompt: .asciz "Would you like to [1] generate private/public keys, [2] encrypt a message, or [3] decrypt a message? [Enter: 1, 2, 3. Program will otherwise exit]:\t"
    startFormat: .asciz "%d"
    startInput: .word 0
    exitMessage: .asciz "Program will now exit\n"
