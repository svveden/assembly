#PURPOSE:	 This program takes input from STDIN and outputs it to STDOUT in ALL CAPS - DOOM
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
	#BUFFER - This is where the data is loaded into from the data
	#	  file and written from into the output file. NEVER >
	#	  16,000
	.equ BUFFER_SIZE, 500
	.lcomm BUFFER_DATA, BUFFER_SIZE

	.section .text

	#STACK POSITIONS
	.equ ST_SIZE_RESERVE, 8
	.equ ST_FD_IN, -4
	.equ ST_FD_OUT, -8
	.equ ST_ARGC, 0
	.equ ST_ARGV_0, 4
	.equ ST_ARGV_1, 8
	.equ ST_ARGV_2, 12

	.globl _start
_start:
	###INITIALIZE PROGRAM###
	#save the stack pointer
	movl %esp, %ebp

	#allocate space for our file descriptors on the stack
	subl $ST_SIZE_RESERVE, %esp

open_files:
open_fd_in:
	###OPEN INPUT FILE###
	#open syscall
	movl $SYS_OPEN, %eax
	#input file name into %ebx
	movl ST_ARGV_1(%ebp), %ebx
	#read-only flag
	movl $O_RDONLY, %ecx
	movl $0666, %edx
	#call linux
	int $LINUX_SYSCALL

store_fd_in:
	#save the given file descriptor
	movl %eax, ST_FD_IN(%ebp)
open_fd_out:
	###OPEN OUTPUT FILE###
	#open the file
	movl $SYS_OPEN, %eax
	#output filename into %ebx
	movl ST_ARGV_2(%ebp), %ebx
	#flags for writing to the file
	movl $O_CREAT_WRONLY_TRUNC, %ecx
	#permission set for new file (if it's created)
	movl $0666, %edx
	#call linux
	int $LINUX_SYSCALL

store_fd_out:
	#store the file descriptor here
	movl %eax, ST_FD_OUT(%ebp)

	###BEGIN MAIN LOOP###
read_loop_begin:
	###READ IN BLOCK FROM INPUT FILE###
	movl $SYS_READ, %eax
	#get input file descriptor
	movl $0 , %ebx
	#the location to read into
	movl $BUFFER_DATA, %ecx
	#the size of the buffer
	movl $BUFFER_SIZE, %edx
	#size of buffer read is returned in %eax
	int $LINUX_SYSCALL

	###EXIT IF WE'VE REACHED THE END###
	#check for end of file marker
	cmpl $END_OF_FILE, %eax
	#if found or on error, go to end
	jle end_loop

continue_read_loop:
	###CONVERT THE BLOCK TO UPPER CASE###
	pushl $BUFFER_DATA #location of buffer
	pushl %eax #SIZE OF THE BUFFER
	call convert_to_upper
	popl %eax #get size back
	addl $4, %esp #restore %esp

	###WRITE THE BLOCK OUT TO THE OUTPUT FILE###
	#size of the buffer
	movl %eax, %edx
	movl $SYS_WRITE, %eax
	#file to use
	movl $1, %ebx
	#location of the buffer
	movl $BUFFER_DATA, %ecx
	int $LINUX_SYSCALL

	###CONTINUE THE LOOP###
	jmp read_loop_begin

end_loop:
	###CLOSE THE FILES###
	movl $SYS_CLOSE, %eax
	movl ST_FD_OUT(%ebp), %ebx
	int $LINUX_SYSCALL

	movl $SYS_CLOSE, %eax
	movl ST_FD_IN(%ebp), %ebx
	int $LINUX_SYSCALL
