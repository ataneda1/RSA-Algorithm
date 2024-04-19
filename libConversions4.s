.global gcd
.global pow
.global modulo
.global cpubexp
.global cprivexp
.global encrypt
.global decrypt

.text
gcd:
	SUB sp, sp, #4
	STR lr, [sp]

	# r11 contains e and r8 contains totient-n. r6 possesses the value of n.
	MOV r4, #2
	MOV r5, #0
	ADD r5, r5, r8
	# r4 starts the factor-loop at 2, with the process eventually ending at r5.
	nextFactor:
	CMP r4, r5
	BLE checkFactorProcess
		# Continue for the value existing as co-prime to totient-n.
		MOV r10, #0
		B returnFollowing
	checkFactorProcess:
		# Determine if r4 exists as a factor for both r11 and r8.
		MOV r3, #0
		ADD r3, r3, r11
		MOV r7, #0
		ADD r7, r7, r4
		MOV r0, r3
		MOV r1, r7
		BL __aeabi_idiv
		MUL r0, r0, r4
		SUB r0, r11, r0
		CMP r0, #0
		#
		BEQ oneFactor
			# Increase the loop with a margin of one if the current factor fails for r11, e.
			ADD r4, r4, #1
			B nextFactor
		oneFactor:
			MOV r3, #0
			ADD r3, r3, r8
			MOV r7, #0
			ADD r7, r7, r4
			MOV r0, r3
			MOV r1, r7
			BL __aeabi_idiv
			MUL r0, r0, r4
			SUB r0, r8, r0
			CMP r0, #0
			#
			BEQ failedValue
				# Increase the loop with a margin of one if the current factor fails for r8, totient-n.
				ADD r4, r4, #1
				B nextFactor
			failedValue:
				# Ask the user to submit e once more.
				MOV r10, #1
				LDR r0, =requestUser
				BL printf
				B returnFollowing
	returnFollowing:
		#

	LDR lr, [sp]
	ADD sp, sp, #4
	MOV pc, lr
.data
	requestUser: .asciz "The user submitted a value of e that never existed as co-prime to totient-n. Please select e once more.\n"
# End the gcd function.

.text
pow:
	#
.data
# End the pow function.

.text
modulo:
	#
.data
# End the modulo function.

.text
cpubexp:
	SUB sp, sp, #4
	STR lr, [sp]

	startPublicExponentLoop:
		MOV r11, #0
		ADD r11, r1, r11
	
		CMP r1, #1
		BLE errorPublicExponent
			CMP r1, r8
			BGE errorPublicExponent2
				BL gcd
				B endPublicExponentLoop
			errorPublicExponent2:
				LDR r0, =incorrectPublicExponent
				BL printf
				B restartProgram2
		errorPublicExponent:
			LDR r0, =incorrectPublicExponent
			BL printf
			B restartProgram2
	restartProgram2:
		LDR r0, =promptPublicExponent
		BL printf
		LDR r0, =followUp
		BL printf
		LDR r0, =format2
		LDR r1, =num2
		BL scanf
		LDR r1, =num2
		LDR r1, [r1]
		B startPublicExponentLoop
	endPublicExponentLoop:
		#
	LDR lr, [sp]
	ADD sp, sp, #4
	MOV pc, lr
.data
	promptPublicExponent: .asciz "Now, enter in the value for the public-key-exponent, a positive integer between 1 and totient-n.\n"
	followUp: .asciz "The value must exist as co-prime to totient-n.\n"
	format2: .asciz "%d"
	num2: .word 0
	incorrectPublicExponent: .asciz "The user submitted an illegitimate value of %d. The request shall restart.\n"
# End the cpubexp function.

.text
cprivexp:
	SUB sp, sp, #4
	STR lr, [sp]

	ADD r8, r8, #1
	MOV r10, #0
	ADD r10, r10, r11
	MOV r0, r8
	MOV r1, r10
	BL __aeabi_idiv
	MOV r8, r0

	LDR lr, [sp]
	ADD sp, sp, #4
	MOV pc, lr
.data
# End the cprivexp function.

.text
encrypt:
	#
.data
# End the encrypt function.

.text
decrypt:
	#
.data
# End the decrypt function.
