	.data
	
	# instruments
win_instrument:		.word	0
loss_instrument:	.word	58
drop_instrument:	.word	115
error_instrument:	.word	3

	.text
	
	.globl	win_theme
	.globl	loss_theme
	.globl	token_drop_noise
	.globl	error_noise

win_theme:
	# plays a victory theme
	li	$v0,	31		# play MIDI syscall
	li	$a1,	500		# duration in ms
	lw	$a2,	win_instrument	# instrument
	li	$a3,	137		# volume
	
	# F Major
	li	$a0,	53	# F
	syscall
	li	$a0,	57	# A
	syscall	
	li	$a0,	60	# C
	syscall
	
	# sleep
	li	$v0,	32		# sleep syscall
	li	$a0,	500		# duration in ms
	syscall
	
	li	$v0,	31		# play MIDI syscall
	# F minor 6
	li	$a0,	53	# F
	syscall
	li	$a0,	56	# Ab
	syscall	
	li	$a0,	62	# D
	syscall
	
	# sleep
	li	$v0,	32		# sleep syscall
	li	$a0,	500		# duration in ms
	syscall
	
	li	$v0,	31		# play MIDI syscall
	# F Major
	li	$a0,	53	# F
	syscall
	li	$a0,	57	# A
	syscall	
	li	$a0,	60	# C
	syscall
	
	# sleep
	li	$v0,	32		# sleep syscall
	li	$a0,	500		# duration in ms
	syscall
	
	li	$v0,	31		# play MIDI syscall
	# F minor 6
	li	$a0,	53	# F
	syscall
	li	$a0,	56	# Ab
	syscall	
	li	$a0,	62	# D
	syscall
	
	# sleep
	li	$v0,	32		# sleep syscall
	li	$a0,	500		# duration in ms
	syscall
	
	li	$v0,	31		# play MIDI syscall
	li	$a1,	1500		# duration in ms
	# C major
	li	$a0,	52	# E
	syscall
	li	$a0,	55	# G
	syscall
	li	$a0,	60	# C
	syscall
	
	# sleep
	li	$v0,	32		# sleep syscall
	li	$a0,	1000		# duration in ms
	syscall

	jr	$ra

loss_theme:
	# plays a sad trombone losing theme
	li	$v0,	33		# play MIDI synchronous syscall
	li	$a1,	500		# duration in ms
	lw	$a2,	loss_instrument	# instrument
	li	$a3,	137		# 
	
	li	$a0,	60	# C
	syscall
	li	$a0,	59	# B
	syscall
	li	$a0,	58	# Bb
	syscall
	li	$a1,	1500	# duration in ms
	li	$a0,	57	# A
	syscall
	
	# sleep
	li	$v0,	32		# sleep syscall
	li	$a0,	1500		# duration in ms
	syscall

	jr	$ra

token_drop_noise:
	li	$v0,	31		# play MIDI syscall
	li	$a0,	90		# note
	li	$a1,	1000		# duration in ms
	lw	$a2,	drop_instrument	# instrument
	li	$a3,	127		# volume
	syscall
	
	# sleep
	li	$v0,	32		# sleep syscall
	li	$a0,	1000		# duration in ms
	syscall
	
	jr	$ra

error_noise:
	# plays the windows error noise
	li	$v0,	31			# play MIDI syscall
	li	$a1,	300			# duration in ms
	lw	$a2,	error_instrument	# instrument
	li	$a3,	127			# volume
	
	# C5 Chord
	li	$a0,	36	# C
	syscall
	li	$a0,	48	# C
	syscall	
	li	$a0,	55	# G
	syscall
	li	$a0,	60	# C
	syscall
	jr $ra
	
	
