	# PURPOSE: This program computes the factorial of a given number
	# non recursively
	#

	.section .data
	.section .text
	.globl _start
_start:
	pushl $4
	call factorial
	addl $4, %esp
	movl %eax, %ebx
	movl $1, %eax
	int $0x80

factorial:
	pushl %ebp			# move old %ebp onto stack
	movl %esp, %ebp			# set up stack frame
	movl 8(%ebp), %ebx		# move argument into %ecx
	movl $1, %ecx		
start_loop:
	cmpl $1, %ebx			# if %ecx == 0, exit
	je exit_factorial
	imull %ebx, %ecx		# multiply %ebx by %ecx
	decl %ebx			# decrement both %ebc and %ecx
	jmp start_loop
exit_factorial:
	movl %ecx, %eax
	movl %ebp, %esi
	popl %ebp
	ret
