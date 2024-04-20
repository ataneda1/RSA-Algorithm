.text
.global shell

shell:
    # Save return
    SUB sp, sp, #4
    STR lr, [sp, #0]

    # Read characters
    //for character in file:
      //BL encrypt/decrypt
      // write encrypted/decrypted character to output_file

    # Return
    shellExit:
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr

.data
