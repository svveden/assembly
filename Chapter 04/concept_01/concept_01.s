	# Purpose: This program will return the square root of a given number.
	# view the answer with 'echo $?'

	.section .data
	.section .text
	.globl _start
_start:
	push $3				# push 2, argument for square
	call square
	addl $4, %esp			# remove argument from stack
	movl %eax, %ebx			# move eax (answer) into ebx for return
	movl $1, %eax			# exit() syscall code
	int $0x80			# call sysint

square:
	pushl %ebp			# save old ebp
	movl %esp, %ebp			# set up stack frame
	movl 8(%ebp), %eax		# moves argument into eax
	imull 8(%ebp), %eax		# multiply argument by itself for square
	movl %ebp, %esp			# move ebp into esp to save esp
	popl %ebp			# pop old ebp back into ebp
	ret
