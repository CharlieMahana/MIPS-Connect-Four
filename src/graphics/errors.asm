	.data
	
column_full_error:	.asciiz	"Illegal Move: this column is already full"
illegal_input_error:	.asciiz "Illegal Input: make sure you enter a legal input sequence"

	.text
	
	.globl	throw_column_full_error
	
throw_column_full_error:
	li	$v0	55			# message dialog syscall
	la	$a0	column_full_error	# address of string to display
	li	$a1	0			# make message error type
	syscall
	jr	$ra
	
throw_illegal_input_error:
	li	$v0	55			# message dialog syscall
	la	$a0	illegal_input_error	# address of string to display
	li	$a1	0			# make message error type
	syscall
	jr	$ra	
