.data
# ======= set up variables to hold user input =======
	#.input: .space 8
	
.text
.global main
	# compile this with -no-pie flag.  gcc example.s -no-pie
	
# ======= set up the strings for printing later =======
.output:
	.string "This has two variables: %i and %i\n"
	
.output2:
	.string "This has five variables: %i and %i and %i and %i and %i\n"
	
# ========== print function ==========
printme:
		# this is how normal print works
	#movq $.output, %rdi 	# string belongs in rdi
	#movq %rax, %rsi		# move result to print to rsi (printf looks here)
	xor %rax, %rax			# can also use movl $0, %rax
	call printf
	ret
	
main:
		# added the next two lines to ensure it runs on my system. Not needed on Vulcan
	pushq	%rbp
	movq	%rsp, %rbp
	
		# here's how the variables set up to print if you have two variables
	movq $10, %rsi			# 1st variable goes in rsi
	movq $2, %rdx			# 2nd variable goes in rdx (which is register with 3rd argument to functions)
	movq $.output, %rdi 	# string belongs in rdi
	xor %rax, %rax			# can also use movl $0, %rax
	call printf
	
		# here's how the variables set up to print if you have more variables
	movq $1, %rsi			# 1st variable goes in rsi
	movq $2, %rdx			# 2nd variable goes in rdx (which is register with 3rd argument to functions)
	movq $3, %rcx			# 3rd variable in rcx (4th register for function arguments)
	movq $4, %r8
	movq $5, %r9
	
	movq $.output2, %rdi 	# string belongs in rdi
	xor %rax, %rax			# can also use movl $0, %rax
	call printf
	
		# clean up and return
	movl $0, %eax
	leave
	ret
