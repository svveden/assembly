	# PURPOSE: This program creates and uses a function
	# to find the maximum of 3 given numbers.
	#

	.section .data
	.section .text
	.globl _start
_start:
	pushl $5		# push 5 onto stack as argument to func
	pushl $24		# push 24 onto stack as argument to func
	pushl $9		# push 9 onto stack as argument to func
	call maximum
	addl $12, %esp
	movl %eax, %ebx
	movl $1, %eax
	int $0x80

	#NOTES: %eax - maximum number
maximum:
	pushl %ebp		# push old ebp onto stack
	movl %esp, %ebp		# set up stack frame
	movl 8(%ebp), %eax	# move first argument into %eax
	cmpl 12(%ebp), %eax		# compare next argument to largest
	jle maximum_swap_1
continue_maximum:
	cmpl 16(%ebp), %eax
	jle maximum_swap_2
	jmp exit_maximum
maximum_swap_1:
	movl 12(%ebp), %eax
	jmp continue_maximum
maximum_swap_2:
	movl 16(%ebp), %eax
	jmp exit_maximum
exit_maximum:
	movl %ebp, %esp
	popl %ebp
	ret
	
	
