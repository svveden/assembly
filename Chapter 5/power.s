	# PURPOSE: Program to illustrate how functions work.
	# This program will compute the value of 2^3 + 5^2
	#
	# Everything in the main program is stored in registers,
	# so the data section doesn't have anything.
	.section .data

	.section .text

	.globl _start
_start:
	pushl $0	#push second argument
	pushl $2	#push first argument
	call power	#call the function
	addl $8, %esp	#move the stack pointer back

	pushl %eax	#save the first answer before calling next func
	pushl $0	#push second arugment
	pushl $5	#push first argument
	call power	#call the function
	addl $8, %esp	#move the stack pointer back
	popl %ebx	#the second answer is already in %eax
	#We save the first answer into %ebx by popping
	addl %eax, %ebx	#add them together
	#result is in %ebx
	movl $1, %eax	#exit
	int $0x80

	#PURPOSE: This function is used to compute the value of
	# a number raised to a power.
	#
	#INPUT: First argument - the base number
	#	Second argument - the power to raise it to
	#
	#
	#OUTPUT: Will give the result as a return value
	#
	#NOTES: The power must be 1 or greater
	#
	#VARIABLES:
	#	%ebx - holds the base number
	#	%ecx - holds the power
	#
	#
	#	-4(%ebx) - holds the current result
	#	%eax is used for temp storage
	#
	.type power, @function
power:
	pushl %ebp	#save old base pointer
	movl %esp, %ebp #make stack pointer the base pointer
	subl $4, %esp	#make space for room of local storage

	movl 8(%ebp), %ebx #move first aruigment into %ebx
	movl 12(%ebp), %ecx #put second argument into %ecx

	movl %ebx, -4(%ebp) #store current result
	cmpl $0, %ecx #check if power is 0
	je zero_power

power_loop_start:
	cmpl $1, %ecx	#if power is 1, we are done
	je end_power
	movl -4(%ebp), %eax #move the current result into %eax
	imull %ebx, %eax #multiply the current result by the base number
	movl %eax, -4(%ebp) #store current result
	decl %ecx 	 #decrease the power
	jmp power_loop_start #run for the next power

zero_power:
	movl $1, %eax
	movl %ebp, %esp
	popl %ebp
	ret
  
end_power:
	movl -4(%ebp), %eax #return value goes into %eax
	movl %ebp, %esp
	popl %ebp
	ret
