.data
# ======= set up variables to hold user input =======
	.input: .space 8
	
.text
.global main
	# compile this with -no-pie flag.  gcc example.s -no-pie
	
# ======= set up the strings for printing later =======
.request:
	.string "Please enter an integer, A = "
	#can also use .asciz == .string
.inputvalue:
	.string "%i"
.output1:
	.string "1. %i! = "
.output1b:
	.string "%i \n"
.output2:
	.string "2. The first %i values of Fibonacci are: "
.output2b:
	.string "%i..."
.output2c:
	.string "\n"
.output3:
	.string "3. Is %i a prime number? "
.outputT:
	.string "True\n"
.outputF:
	.string "False\n"
	

# ========== print function ==========
printme:
	#movq $.output, %rdi 	# string belongs in rdi
	#movq %rax, %rsi			# move result to print to rsi (printf looks here)
	xor %rax, %rax			# can also use movl $0, %rax
	call printf
	ret


# ========== factorial functions ==========
calcFactorial:
		# place rsi in stack for safekeeping
	pushq %rsi
		# print initial string
	movq $.output1, %rdi 	# string belongs in rdi
	call printme
		# place the value in appropriate registers for multiplication
	xor %rax, %rax
	xor %rbx, %rbx
	popq %rax				# A in rax
	movq %rax, %rbx			# also place A in rbx, prep for multiplication

		# place a counter in an appropriate location
	xor %rcx, %rcx
	movq %rax, %rcx			# counter in rcx = A
	
doFactorialIteration:
	subq $1, %rbx			# subtract 1 from rbx, prep for multiplication
	imul %rbx, %rax			# multiple A by itself, result in rax
	subq $1, %rcx			# subtract 1 from counter in rcx
	cmpq $1, %rcx			# compare counter with 1
	jg doFactorialIteration	# if counter (rcx) > 1, loop
		# print the result
	movq %rax, %rsi
	movq $.output1b, %rdi 	# string belongs in rdi
	call printme
	ret
	
# ========== Fibonacci functions ==========
calcFib:
		# push A to the stack for safekeeping
	pushq %rsi
		# print the initial string
	movq $.output2, %rdi 	# string belongs in rdi
	call printme
		# print the first number
	movq $1, %rsi
	movq $.output2b, %rdi
	call printme
		# check to determine if A = 1, if so we're done
	popq %rax
	cmpq $1, %rax		# if rax (A) = 1, then we're done
	je fibFinish	
		# print the second number
	pushq %rax			# push A to the stack for safekeeping
	movq $1, %rsi
	movq $.output2b, %rdi
	call printme
		# check to see if A = 2, we're done, else start the sequence
	popq %rax
	cmpq $2, %rax			# if rax (A) = 2, then we're done
	je fibFinish
	pushq %rax
	
fibInitialVar:
		# initialize variables
	xor %rax, %rax			# we'll use this for i-1 value, and result
	xor %rbx, %rbx			# we'll use this for i-2 value
	xor %rcx, %rcx			# we'll use this for counter
	xor %rdx, %rdx			# we'll use this to hold A for comparison
	movq $1, %rax			# set toe lines set initial values
	movq $1, %rbx			# 
	popq %rcx				# move A into rcx to use for comparison later
	movq $2, %rdx			# move 1 into rdx for a counter
	pushq %rbx				# next two lines set up the stack with i-2, and i-1
	pushq %rax

fibIteration:
	popq %rax				# put i-1 value in rax
	popq %rbx				# put i-2 value in rbx
	pushq %rax				# put the next i-2 value on the stack for the next iteration
	addq %rbx, %rax			# add, result in rax, which is now i
	pushq %rax				# put the next i-1 value on the stack for the next iteration
		# save values before we print
	pushq %rcx
	pushq %rdx
		# print the result
	movq %rax, %rsi
	movq $.output2b, %rdi
	call printme
		# recall the values and determine if we're complete
	popq %rdx
	popq %rcx
	
	inc %rdx
	cmpq %rcx, %rdx			# if rdx (counter) < rcx (A), then loop
	jl fibIteration
		# else clean up, print newline and return
	popq %rax
	popq %rax
fibFinish:
	movq $.output2c, %rdi 	# "\n" string belongs in rdi
	call printme
	xor %rax, %rax			
	xor %rbx, %rbx			
	xor %rcx, %rcx			
	xor %rdx, %rdx	
	ret
	
	
	
# ========== prime functions ==========
isItPrime:
		# save the number before we call print
	pushq %rsi
		# print the start of the answer
	movq $.output3, %rdi 	# string belongs in rdi
	call printme
		# place the counter value in appropriate registers
	xor %rbx, %rbx
	movq $2, %rbx			# start at 2
	
checkAnother:
		# place the value in appropriate registers
	xor %rax, %rax
	popq %rax				# A in rax, get ready to divide
	pushq %rax				# push it back on the stack for next time
	#movq %rsi, %rax		# A in rax, get ready to divide
	cqto					# sign extend rax into rdx
	idivq %rbx				# divide rdx:rax (A) by rbx, result placed in rax, remainder in rdx
		# check rdx (modulus)
	cmpq $0, %rdx			# if modulus is 0, it divides evenly, and this is not prime
	je primeAnswerFalse		# once we know it's not a prime, go print result
		# else
	addq $1, %rbx			# increment rbx, the number we are using to divide / check prime
	cmpq %rbx, %rax			# if A (rax) > rbx (# we're using to check), we have more numbers to test
	jg checkAnother
		# if A <= rbx, then we've tested all previous numbers, and A is prime
	movq $.outputT, %rdi 	# string belongs in rdi
	call printme
	popq %rax				# clean up the stack
	ret
	
primeAnswerFalse:
	movq $.outputF, %rdi 	# string belongs in rdi
	call printme
	popq %rax				# clean up the stack
	ret
	
# ========== main ==========

main:
# added the next two lines to ensure it runs on my system. Not needed on Vulcan
	pushq	%rbp
	movq	%rsp, %rbp
		
	# ======= Obtain user input =======
		# print the first input string
	movq $.request, %rdi 	# string belongs in rdi
	xor %rax, %rax			# can also use movl $0, %rax
	call printf
	
		# get the input value
	movq $.input, %rsi
	leaq	.inputvalue(%rip), %rdi
	xor %rax, %rax			# can also use movl $0, %rax
	call scanf				# this should also work, but doesn't: call	__isoc99_scanf@PLT
	
		# place A in a location that isn't destroyed by system calls
	movq (.input), %r12		# A is r12 for safekeeping

		
	# ======= use this section to hard code the number =======
	#movq $3, %r12			# A
	
	
	# ======= Problem 1: A! =======
	movq %r12, %rsi
	call calcFactorial
	
	# ======= Problem 2: Fibonacci =======
	movq %r12, %rsi
	call calcFib
	
	# ======= Problem 3: Is it Prime =======
	movq %r12, %rsi
	call isItPrime
	

	# clean up and return
	movl $0, %eax
	leave
	ret
