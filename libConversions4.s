.global gcd
.global pow
.global modulo
.global cpubexp
.global cprivexp
.global encrypt
.global decrypt

.text
gcd:
	x
.data
# End the gcd function.

.text
pow:
	# Assume that the value of the exponent exists in r11, temporarily in this function.
	# Assume that the base number attached to the exponent exists in r10, temporarily in this function.
	# Store the value of r11 into r5 for utilization later.
	MOV r5, #0
	MOV r5, r5, r11
	# Set the start of the loop-process to 1 in r4, and r11 in r5.
	MOV r4, #1
	ADD r5, r5, #0

	startLoop:
		CMP r4, r5
		BLT multiplyExponent
			B endLoop
		multiplyExponent:
			MUL r10, r10, r10
			ADD r4, r4, #1
			B startLoop
	endLoop:
		# The final value of, x^y for example, stores into r10.
.data
# End the pow function.

.text
modulo:
	x
.data
# End the modulo function.

.text
cpubexp:
	x
.data
# End the cpubexp function.

.text
cprivexp:
	x
.data
# End the cprivexp function.

.text
encrypt:
	x
.data
# End the encrypt function.

.text
decrypt:
	x
.data
# End the decrypt function.
