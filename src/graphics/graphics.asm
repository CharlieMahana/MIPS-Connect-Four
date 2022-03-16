	.data
# graphical components
bitmap:	.word	0x10040000
board:	.word	0x10080000
token:	.word	0x100C0000

# file paths
fboard:	.asciiz	"board.dat"
ftoken:	.asciiz	"token.dat"

	
	.text
	
	.globl 	initialize_graphics

initialize_graphics:
	# initialize_graphics is a procedure whose purpose is load all resources
	# and initialize the bitmap display for a game of connect-four. It
	# beings by loading all external resources such as the board and 
	# connect-four tokens and then initializes the display by drawing
	# a blank board that is ready for gameplay. This procedure should be 
	# run before calling any other graphical procedures. 
	
_load_board:
	# load the game board into memory from board.dat
	
	# open board.dat
	li	$v0, 	13		# system call for open file
	la	$a0,	fboard		# input file path
	li	$a1,	0		# read flag
	li	$a2,	0		# ignore mode
	syscall
	
	# ensure that an error has not occured (i.e. $v0 is negative)
	ble	$v0,	$zero,	_abort
	
	# save file descriptor for reading
	move	$t0,	$v0
	
	# read data from board.dat into memory
	li	$v0,	14		# system call for read from file
	move	$a0,	$t0		# file descriptor
	lw	$a1,	board		# address of input buffer
	li	$a2,	0x40000		# maximum number of characters to read
	syscall
	
	# ensure that an error has not occured (i.e. $v0 is negative)
	ble	$v0,	$zero,	_abort
	
	# close file to prevent memory leak
	li	$v0,	16		# system call for close file
	move	$a0,	$t0		# file descriptor
	syscall
	
_load_token:

	# load the game token into memory from token.dat
	
	# open token.dat
	li	$v0,	13		# system call for open file
	la	$a0,	ftoken		# input file path
	li	$a1,	0		# read flag
	li	$a2,	0		# ignore mode
	syscall
	
	# ensure that an error has not occured (i.e. $v0 is negative)
	ble	$v0,	$zero,	_abort
	
	# save file descriptor for reading
	move	$t0,	$v0
	
	# read data from token.dat into memory
	li	$v0,	14		# system call for read from file
	move	$a0,	$t0		# file descriptor
	lw	$a1,	token		# address of input buffer
	li	$a2,	0x100		# maximum number of characters to read
	syscall
	
	# ensure that an error has not occured (i.e. $v0 is negative)
	ble	$v0,	$zero,	_abort
	
	# close file to prevent memory leak
	li	$v0,	16		# system call for close file
	move	$a0,	$t0		# file descriptor
	syscall
	
_initialize_graphics_buffer:

	# initialize the graphics buffer to all white
	lw	$t0,	bitmap		# start of display buffer and current pixel
	lw	$t1,	board		# end of display buffer
	li	$t2,	0x00ffffff	# the color white
_loop0:	# loop through graphics buffer setting every pixel to white
	bge	$t0,	$t1,	_draw_game_board
	sw	$t2,	($t0)		# color current pixel white
	addi	$t0,	$t0,	4	# increment current pixel
	j 	_loop0			# continue loop
	
_draw_game_board:

	# load the game board into the graphics buffer
	lw	$t0,	bitmap		# start of display buffer and current pixel
	lw	$t1,	board		# end of display buffer
	lw	$t2,	board		# corresponding pixel in board
_loop1:	# loop through graphics buffer setting each pixel to the proper board pixel
	bge	$t0,	$t1,	_end_procedure
	lw	$t3,	($t2)		# load pixel value from board
	sw	$t3,	($t0)		# set pixel in bitmap
	addi	$t0,	$t0,	4	# increment bitmap pixel
	addi	$t2,	$t2,	4	# increment board pixel
	j	_loop1			# continue loop
	
_end_procedure:
	jr	$ra			# return from initalization procedure
		
_abort:	
	# if an error occurs during initialization, abort program
	li	$v0	10		# system call for exiting
	syscall	