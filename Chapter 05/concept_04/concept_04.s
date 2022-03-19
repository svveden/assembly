#PURPOSE: This program creates a file called heynow.txt and writes the words
	# "This yard bird tastes like fried toad turd!" into it.
	#

	.section .data

	####CONSTANTS####

	#system call numbers
	.equ SYS_OPEN, 5
	.equ SYS_WRITE, 4
	.equ SYS_READ, 3
	.equ SYS_CLOSE, 6
	.equ SYS_EXIT, 1

	.equ O_RDONLY, 0
	.equ O_CREAT_WRONLY_TRUNC, 03101

	#standard file descriptors
	.equ STDIN, 0
	.equ STDOUT, 1
	.equ STDERR, 2

	#system call interrupt
	.equ LINUX_SYSCALL, 0x80
	.equ END_OF_FILE, 0 #This is the return value of read == EOF
	.equ NUMBER_ARGUMENTS, 2

	.section .bss
	#BUFFER
	.equ BUFFER_SIZE, 50
	.lcomm BUFFER_DATA, BUFFER_SIZE

	.section .text

	#STACK POSITIONS
	.equ ST_SIZE_RESERVE, 4
	.equ ST_FD_OUT, -4
	.equ ST_ARGC, 0
	.equ ST_ARGV_0, 4
	.equ ST_ARGV_1, 8
	.equ ST_ARGV_2, 12

	msg:	 .ascii "This yard bird tastes like fried toad turd!\0"
	title:	.ascii "heynow.txt\0"

	.globl _start
_start:
	movl %esp, %ebp
	subl $ST_SIZE_RESERVE, %esp

open_file:
	movl $SYS_OPEN, %eax
	movl $title, %ebx
	movl $O_CREAT_WRONLY_TRUNC, %ecx
	movl $0666, %edx
	int $LINUX_SYSCALL
	movl %eax, ST_FD_OUT(%ebp)
write_file:
	movl %eax, %edx
	movl $SYS_WRITE, %eax
	movl ST_FD_OUT(%ebp), %ebx
	movl $msg, %ecx
	movl $43, %edx
	
	int $LINUX_SYSCALL

	movl $SYS_CLOSE, %eax
	movl ST_FD_OUT(%ebp), %ebx
	int $LINUX_SYSCALL

	###EXIT###
	movl $SYS_EXIT, %eax
	movl $0, %ebx
	int $LINUX_SYSCALL
