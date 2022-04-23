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
	li	$a2,	0x1000		# maximum number of characters to read
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
	
	.globl place_token

place_token:
	# place token is a procedure that takes a location and color and
	# places a token on the board at that location
	# a0: horizontal location (left to right indexed at 0)
	# a1: vertical location (top to bottom indexed at 0)
	# a3: color (0 for red, non-zero for yellow)

_initialize_cell_location:
	# determine top left corner of token location cell
	li	$s0, 	0x10040000	# cell location and start of buffer
	
_account_for_horizontal_padding:
	# adjust cell location to account for 16 pixel padding on left
	add	$s0,	$s0,	68	# shifts current location by 16 pixels to the 17th pixel
	
_account_for_vertical_padding:
	# adjust cell location to accoutn for 64 pixel padding on top
	add 	$s0,	$s0,	0x10000	# shifts current location down by 64 pixels
	
_shift_to_horizontal_location:
	# shift cell location horizontally to proper location
	li	$t0,	0		# set iterator to 0
_loop2:	bge	$t0,	$a0	_shift_to_vertical_location
	add	$s0,	$s0,	0x80	# shift current location horizontally by one token cell
	add	$t0,	$t0,	1	# increment iterator by 1
	j 	_loop2

_shift_to_vertical_location:
	# shift cell location vertically to proper location
	li	$t0,	0		# set iterator to 0
_loop3:	bge	$t0,	$a1,	_determine_token_color
	add	$s0,	$s0,	0x8000	# shift current location vertically by one token cell
	add	$t0,	$t0,	1	# increment iterator by 1
	j	_loop3

_determine_token_color:
	# sets the token color for drawing
	bgt	$a2,	0,	_else0	# if color is not 0
	li	$s1,	0xe53835	# sets token color to red
	j	_draw_token		# go to next step
_else0:	li	$s1,	0xffee58	# if color is not 0 set color to yellow
	j	_draw_token		# go to next step
	
_draw_token:
	# draw token at cell location
	li	$t0,	0		# horizontal cell iterator
	li	$t1,	0		# vertical cell iterator
	lw	$t2,	token		# token data iterator
	
_loop4:	blt 	$t0,	32,	_loop5	# when current location hasn't yet reached the edge of the cell
	li	$t0,	0		# reset horizontal cell iterator
	add	$t1,	$t1,	1	# increment vertical cell iterator
	add	$s0,	$s0,	0x380	# move location from rightmost side of current cell row to leftmost side of lower cell row
_loop5:	bge	$t1,	32,	_end_procedure	# when finished iterating, return from procedure
	lw	$t3,	($t2)		# set $t3 to the color at current location in token data
	bne	$t3,	0x0,	_else1	# if color at current location in token data isn't black
	sw	$s1,	($s0)		# draw pixel
_else1:	add	$t0,	$t0,	1	# increment horizontal cell iterator
	add	$s0,	$s0,	4	# move current location horizontally by one pixel
	add	$t2,	$t2,	4	# move location in token data by one pixel
	j	_loop4

	

	
	
