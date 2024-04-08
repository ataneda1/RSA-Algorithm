.text
.global main
main:
	SUB sp, sp, #4
	STR lr, [sp]

	# Code to prompt the user for the value of p and determine if the value of p falls under 50 and exists as prime.
	# Run the below code in a do-while loop that ends for legitimate values. Before the if-statements, store the value in r2.
	# The if-statements at the end of the loop check if the value of p falls under 50 and if it exists as prime.
	# If the value of p falls under 50 and exists as prime, end the loop.
	tryAgain:
	LDR r0, =prompt1
	BL printf
	LDR r0, =format1
	LDR r1, =num1
	BL scanf
	LDR r0, =num1
	LDR r0, [r0]
	MOV r2, r0 # Store the value of p into r2.
	CMP r2, #50
	BLT legitimateValue
		LDR r0, =errorFirst
		BL printf
		B tryAgain
	legitimateValue:
		ADD r2, r2, #0
	# Add the missing code above.

	# Code to prompt the user for the value of q and determine if the value of q falls under 50 and exists as prime.
	# Run the below code in a do-while loop that ends for legitimate values. Before the if-statements, store the value in r3.
	# The if-statements at the end of the loop check if the value of q falls under 50 and if it exists as prime.
	# If the value of q falls under 50 and exists as prime, end the loop.
	tryAgain2:
	LDR r0, =prompt2
	BL printf
	LDR r0, =format2
	LDR r1, =num2
	BL scanf
	LDR r0, =num2
	LDR r0, [r0]
	MOV r3, r0 # Store the value of q into r3.
	CMP r3, #50
	BLT legitimateValue2
		LDR r0, =errorFirst
		BL printf
		B tryAgain2
	legitimateValue2:
		ADD r3, r3, #0
	# Add the missing code above.

	MUL r4, r2, r3 # Calculate the value of n, storing it in r4, and eventually r3.
	MOV r0, #1
	SUB r2, r2, r0
	SUB r3, r3, r0
	MUL r2, r2, r3 # Calculate the value of totient-n, storing it in r2.
	MOV r3, r4

	# Code to prompt the user for the value of the exponent key, e, and determine if it is positive, between 1 and totient-n, and co-prime to totient-n.
	# Run the below code in a do-while loop that ends with legitimate values. Store the value in r7 before anything else.
	# After storing the value in r7, the cpubexp function checks if the value is positive and between 1 and totient-n. If so, set r6 to 1.
	# The first if-statement in the do-while loop detects if r6 is 1, and if so, it then runs the gcd function.
	# For the gcd function, the function checks if the value is co-prime to totient-n. If so, set r6 to 1.
	# The next if-statement in the do-while loop checks if r6 is 1, and if so, it ends the loop.
	# Alternatively, the cpubexp function itself can call the gcd function, then adjusting the rest of the process accordingly.
	LDR r0, =prompt3
	BL printf
	LDR r0, =format3
	LDR r1, =num3
	BL scanf
	LDR r0, =num3
	LDR r0, [r0]
	MOV r6, r0 # Store the value of the exponent key in r6.
	BL cpubexp
	BL gcd
	# Add the missing code above.

	# Code to calculate the value of the private-key-exponent of d.
	# This part of the code runs the cprivexp function.
	BL cprivexp
	MOV r7, r0 # Store the value of d into r7.

	# Code to encrypt the message, following the user inputting a starting string.
	# The code here shall call the encrypt function. For each letter of the messasge, utilize the function to calculate the value of c.
	# The value of c then prints to an output file, with the process repeating for the remainder of the string.
	# The encrypt function calls on both the pow and modulo functions to calculate the value of c.
	# Utilize a do-while loop that ends after the string finishes translating with the encrypt function.
	LDR r0, =prompt4
	BL printf
	LDR r0, =format4
	LDR r1, =num4
	BL scanf1
	LDR r0, =num4
	LDR r0, [r0]
	BL encrypt
	# Add the missing code above.
	
	# Code to decrypt the message, after importing in the text file created earlier.
	# After importing the text file, the code runs the decrypt function. For each value of c in the string, utilize the function to decrypt it.
	# The value of c then converts into a letter to then display for the user, with the process repeating itself for the remainder of the string.
	# The decrypt function utilizes both the pow and modulo functions to calculate the value of m, and the final letter.
	# Utilize a do-while loop that ends after the string finishes printing out the encrypted message with the decrypt function.
	BL decrypt
	LDR r0, =output1
	LDR r1, =num5
	# Add the missing code above.

	LDR lr, [sp]
	ADD sp, sp, #4
	MOV pc, lr
.data
	prompt1: .asciz "Hello. To encrypt and decrypt a message utilizing the RSA Algorithm, first enter in a prime number lower than the value of 50.\n"
	prompt2: .asciz "Now, enter in a second value that exists as prime and lower than the value of 50.\n"
	format1: .asciz "%d"
	num1: .word 0
	format2: .asciz "%d"
	num2: .word 0
	prompt3: .asciz "Enter in the value of the exponent key of e. It must exist as positive, between 1 and totient-n, and co-prime to totient-n.\n"
	format3: .asciz "%d"
	num3: .word 0
	prompt4: .asciz "Enter in the message to encrypt.\n"
	format4: .asciz "%s"
	num4: .space 40
	output1: .asciz "%s"
	format5: .asciz "%s"
	num5: .space 40
	errorFirst: .asciz "The user submitted an incorrect value. Try again.\n"
