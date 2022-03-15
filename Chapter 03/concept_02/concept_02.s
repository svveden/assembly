	#VARIABLES: The registers have the following uses:
	#
	# %edi - Holds the index of the data being examined
	# %ebx - Largest data item found
	# %eax - Current data item
	#
	# The following memory locations are used:
	#
	# data_items - contains the item data. A 0 is used to
	# terminate the data.
	#
	#

	.section .data

data_items:
	.long 3,67,34,222,45,75,54,34,44,33,22,11,66,69

	.section .text

	.globl _start
_start:
	movl $0, %edi				# move 0 into index register
	movl data_items(, %edi, 4) , %eax	# load the first byte of data
	movl %eax, %ebx				# first data item = largest

start_loop:					# start loop
	cmpl $69, %eax				# check to see if we've hit 0
	je loop_exit				# jump to exit if 0
	incl %edi				# increment %edi
	movl data_items(, %edi, 4), %eax	# load next
	cmpl %ebx, %eax				# compare items
	jge start_loop				# jump to beginning if not big

	movl %eax, %ebx				# move value into largest
	jmp start_loop				# jump to beginning

loop_exit:
	# %ebx is the status code for the exit system call
	# and it already has the maximum number
	movl $1, %eax				# 1 is the exit() syscall
	int $0x80
