.text
.global main
main:
	# Push the stack.
	SUB sp, sp, #4
	STR lr, [sp]

	# Code to initalize the program, regarding user-inputs.
	LDR r0, =initialPrompt
	BL printf
	MOV r9, #0

	# Prompt for the user to submit the starting value.
	LDR r0, =prompt1
	BL printf
	LDR r0, =format1
	LDR r1, =num1
	BL scanf

	# Start the loop of the program.
	startProgramLoop:
		# Store the value of the user-value into r1.
		LDR r1, =num1
		LDR r1, [r1]
		MOV r11, #0
		ADD r11, r1, r11
		# Determine if the user submitted -1 as the input. End the program if the value exists as -1.
		CMP r1, #-1
		BEQ endProgramLoop
			# Otherwise, determine if the user submitted a value less than or equal to 2.
			CMP r1, #2
			# Display an error message for any illegitimate values.
			BLE ErrorMessage
				# For any legitimate values, run the second loop.
				# Store the user-input, n, into r8.
				MOV r8, r1
				MOV r4, #0
				ADD r4, r4, r8
				MOV r0, r4
				MOV r1, #2
				BL __aeabi_idiv
				# Set r4 to 2 and r5 to half of the user-input.
				# r4 refers to the start of the second loop.
				# r5 refers to the end of the second loop, since no factor can exist beyond n/2.
				MOV r4, #2
				MOV r5, r0

				# Initiate the factor-loop process.
				factorLoop:
				# For all integers within the range of 2 and n/2, check if they exist as factors.
				CMP r4, r5
				BLE checkFactor
					# Print that the value is prime.
					ADD r9, r9, #1
					CMP r9, #2
					BEQ secondPrime
					MOV r7, #0
					ADD r7, r7, r11
					LDR r0, =output1
					MOV r1, r11
					BL printf
					B restartProgram
				checkFactor:
					#
					# For each value of r4, determine if that exists as a factor of n.
					# To do so, divide n with the value of r4, before multiplying the result with r4.
					# Subtract that final result from n. If the final result exists as zero, then r4 is a factor.
					# Otherwise, r4 is not factor.
					# For example: n = 9; r4 = 3; 9 / r4 = 3; 3 * r4 = 9; n - 9 = 0; r4 is a factor
					# For example: n = 9; r4 = 2; 9 / r4 = 4 due to no remainder in this code; r4 is not a factor
					MOV r3, #0
					ADD r3, r3, r8
					MOV r6, #0
					ADD r6, r6, r4
					MOV r0, r3
					MOV r1, r6
					BL __aeabi_idiv
					MUL r0, r0, r4
					SUB r0, r8, r0
					CMP r0, #0
					#
					BEQ compositeValue
						# Increase the loop with a margin of one.
						MOV r10, #1
						ADD r4, r4, r10
						B factorLoop
					compositeValue:
						# Print that the value exists as composite.
						LDR r0, =output2
						MOV r1, r11
						BL printf
						B restartProgram
					B endProgramLoop
			ErrorMessage:
				# Print the corresponding error message for illegitimate values.
				LDR r0, =prompt2
				BL printf
				B restartProgram

		# Restart the program, if necessary.
		restartProgram:
		LDR r0, =prompt1
		BL printf
		LDR r0, =format1
		LDR r1, =num1
		BL scanf	
		B startProgramLoop
	endProgramLoop:
		# This placeholder value ends the program.
		MOV r9, #0
		B endOverallProgram

	# Transfer into the next phase of the program following verification of both p and q. r7 and r9 contain the values.
	secondPrime:
	MOV r9, r11
	MOV r0, #0
	MOV r1, #0
	MOV r2, #0
	MOV r3, #0
	MOV r4, #0
	MOV r5, #0
	MOV r6, #0
	MOV r8, #0
	MOV r10, #0
	MOV r11, #0

	# Calculate the value of n, storing it into r6.
	MUL r6, r7, r9

	# Calculate the value of totient-n, storing it into r8.
	SUB r7, r7, #1
	SUB r9, r9, #1
	MUL r8, r7, r9
	MOV r7, #0
	MOV r9, #0

	# Display the prompt for the public-key-exponent.
	returnPublic:
	LDR r0, =promptPublicExponent
	BL printf
	LDR r0, =followUp
	BL printf
	LDR r0, =format2
	LDR r1, =num2
	BL scanf
	LDR r1, =num2
	LDR r1, [r1]

	BL cpubexp
	CMP r10, #1
	BEQ returnPublic
	# Proceed to the next process. r6 contains n, r11 contains e, and r8 contains totient-n.
	MOV r0, #0
	MOV r1, #0
	MOV r2, #0
	MOV r3, #0
	MOV r4, #0
	MOV r5, #0
	MOV r7, #0
	MOV r9, #0
	MOV r10, #0

	BL cprivexp
	# r8 now contains the value of the private-key-exponent, d.

	# Move into the encryption-phase of the program.
	MOV r0, #0
	MOV r1, #0
	MOV r2, #0
	MOV r3, #0
	MOV r4, #0
	MOV r5, #0
	MOV r7, #0
	MOV r9, #0
	MOV r10, #0

	endOverallProgram:
		MOV r9, #0

	# Pop the stack.
	LDR lr, [sp]
	ADD sp, sp, #4
	MOV pc, lr
.data
	initialPrompt: .asciz "Hello. To begin the RSA-Algorithm encryption-decryption process, enter in two positive prime integers under 50.\n"
	prompt1: .asciz "Enter in one of the two prime values now. To end the program now, submit -1.\n"
	format1: .asciz "%d"
	num1: .word 0
	output1: .asciz "Number %d is prime\n"
	output2: .asciz "Number %d is not prime\n"
	prompt2: .asciz "The user submitted an illegitimate value. Only -1 and integers higher than 2 are allowed. The request shall restart.\n"
	promptPublicExponent: .asciz "Now, enter in the value for the public-key-exponent, a positive integer between 1 and totient-n.\n"
	followUp: .asciz "The value must exist as co-prime to totient-n.\n"
	format2: .asciz "%d"
	num2: .word 0
