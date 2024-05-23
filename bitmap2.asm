#Start address of the screen Bitmap
.eqv MONITOR_SCREEN 0x10010000 
#Start address of MMIO
.eqv KEY_CODE 0xFFFF0004
.eqv KEY_READY 0xFFFF0000 
#List of color
.eqv YELLOW 0x00FFFF00
.eqv BLACK 0x00000000
#---------------------------------
.eqv MASK_CAUSE_KEYBOARD 0x0000034 

.text
# Set the position in center of the screen 
	li $t0, MONITOR_SCREEN #Loads the start address of the screen
	li $k0, KEY_CODE
	li $k1, KEY_READY
	
	addi $s0, $zero, 2048 # offset 1 line 512*4
	
	addi $t3, $zero, 235
	mult $s0, $t3
	mflo $t4
	add $t0, $t0, $t4
	sll $t4, $t3, 2
	add $t0, $t0, $t4	#Determine the starting position

	addi $s4, $zero, 236	# xA
	addi $s5, $zero, 236	# yA
	addi $s6, $zero, 269	# xB
	addi $s7, $zero, 269	# yB
#Drawing the circle
	add $t8, $t0, 0
	li $t1, YELLOW
	jal drawing_circle
	
	addi $t9, $zero, 0	# Direction (1, 2, 3, 4) = (uo, down, left, right)
	li $a1,80
moving:
	ble $t6,5,else 
	li $a1,80
	else:
	addi $a0,$a1,0	#sleep
	li $v0, 32
	syscall
	nop
	
	lw $t1, 0($k1) 
	beq $t1, $zero, continue
	
	MakeIntR: 	# Enable soft interrupt when key is received
	teqi $t1, 1
	
	continue:
	beq $t9, 1, up
	beq $t9, 2, down
	beq $t9, 3, left
	beq $t9, 4, right
	nop
	j moving
	
	up:
	addi $t6,$t6,1
	add $t0, $t8, 0
	li $t1, BLACK
	jal drawing_circle
	add $t0, $t8, 0
	sub $t0, $t0, $s0
	sub $t0, $t0, $s0
	add $t8, $t0, 0
	li $t1, YELLOW
	jal drawing_circle
	nop
	addi $s5, $s5, -2
	addi $s7, $s7, -2
	slti $t1, $s5, 3
	bne $t1, $zero, to_down
	j moving
	to_down:
	addi $t9, $zero, 2
	j moving
	
	down:
	addi $t6,$t6,1
	add $t0, $t8, 0
	li $t1, BLACK
	jal drawing_circle	
	add $t0, $t8, 0
	add $t0, $t0, $s0
	add $t0, $t0, $s0
	add $t8, $t0, 0
	li $t1, YELLOW
	jal drawing_circle
	nop
	addi $s5, $s5, 2
	addi $s7, $s7, 2
	slti $t1, $s7, 511
	beq $t1, $zero, to_up
	j moving
	to_up:
	addi $t9, $zero, 1
	j moving
	
	left:
	addi $t6,$t6,1
	add $t0, $t8, 0
	li $t1, BLACK
	jal drawing_circle	
	add $t0, $t8, 0
	addi $t0, $t0, -8
	add $t8, $t0, 0
	li $t1, YELLOW
	jal drawing_circle
	nop
	addi $s4, $s4, -2
	addi $s6, $s6, -2
	slti $t1, $s4, 3
	bne $t1, $zero, to_right
	j moving
	to_right:
	addi $t9, $zero, 4
	j moving
	
	right:
	addi $t6,$t6,1
	add $t0, $t8, 0
	li $t1, BLACK
	jal drawing_circle	
	add $t0, $t8, 0
	addi $t0, $t0, 8
	add $t8, $t0, 0
	li $t1, YELLOW
	jal drawing_circle
	nop
	addi $s4, $s4, 2
	addi $s6, $s6, 2
	slti $t1, $s6, 511
	beq $t1, $zero, to_left
	j moving
	to_left:
	addi $t9, $zero, 3
	j moving
	
drawing_circle:

	addi $t7, $ra, 0
	addi $s1, $zero, 13	# number of empty pixels in the top
	addi $s2, $zero, 4	# number of the pixel need to draw
	addi $s3, $zero, 0	# number of empty pixels in the middle
	jal drawing_line	# 1
	nop

	addi $s1, $zero, 10
	addi $s2, $zero, 7	
	addi $s3, $zero, 0	
	jal drawing_line	# 2
	nop
	
	addi $s1, $zero, 8
	addi $s2, $zero, 6	
	addi $s3, $zero, 6	
	jal drawing_line	# 3
	nop
	
	addi $s1, $zero, 7
	addi $s2, $zero, 4	
	addi $s3, $zero, 12	
	jal drawing_line	# 4
	nop
	
	addi $s1, $zero, 5
	addi $s2, $zero, 4	
	addi $s3, $zero, 16	
	jal drawing_line	# 5
	nop
	
	addi $s1, $zero, 4
	addi $s2, $zero, 4	
	addi $s3, $zero, 18	
	jal drawing_line	# 6
	nop
	
	addi $s1, $zero, 4
	addi $s2, $zero, 2	
	addi $s3, $zero, 22	
	jal drawing_line	# 7
	nop
	
	addi $s1, $zero, 3
	addi $s2, $zero, 3	
	addi $s3, $zero, 22	
	jal drawing_line	# 8
	nop
	
	addi $s1, $zero, 2
	addi $s2, $zero, 3	
	addi $s3, $zero, 24	
	jal drawing_line	# 9
	nop
	
	addi $s1, $zero, 2
	addi $s2, $zero, 2	
	addi $s3, $zero, 26	
	jal drawing_line	# 10
	nop
	
	addi $s1, $zero, 1
	addi $s2, $zero, 3	
	addi $s3, $zero, 26	
	jal drawing_line	# 11
	nop
	
	addi $s1, $zero, 1
	addi $s2, $zero, 2	
	addi $s3, $zero, 28	
	jal drawing_line	# 12
	nop
	
	jal drawing_line	# 13
	nop
	
	addi $s1, $zero, 0
	addi $s2, $zero, 3	
	addi $s3, $zero, 28	
	jal drawing_line	# 14
	nop
	
	addi $s1, $zero, 0
	addi $s2, $zero, 2	
	addi $s3, $zero, 30	
	jal drawing_line	# 15
	nop
	
	jal drawing_line	# 16
	nop
	jal drawing_line	# 17
	nop
	jal drawing_line	# 18
	nop
	jal drawing_line	# 19
	nop
	jal drawing_line	# 20
	nop
	
	addi $s1, $zero, 0
	addi $s2, $zero, 3	
	addi $s3, $zero, 28	
	jal drawing_line	# 21
	nop
	
	addi $s1, $zero, 1
	addi $s2, $zero, 2	
	addi $s3, $zero, 28	
	jal drawing_line	# 22
	nop
	
	jal drawing_line	# 23
	nop
	
	addi $s1, $zero, 1
	addi $s2, $zero, 3	
	addi $s3, $zero, 26	
	jal drawing_line	# 24
	nop
	
	addi $s1, $zero, 2
	addi $s2, $zero, 2	
	addi $s3, $zero, 26	
	jal drawing_line	# 25
	nop
	
	addi $s1, $zero, 2
	addi $s2, $zero, 3	
	addi $s3, $zero, 24	
	jal drawing_line	# 26
	nop
	
	addi $s1, $zero, 3
	addi $s2, $zero, 3	
	addi $s3, $zero, 22	
	jal drawing_line	# 27
	nop
	
	addi $s1, $zero, 4
	addi $s2, $zero, 2	
	addi $s3, $zero, 22
	jal drawing_line	# 28
	nop
	
	addi $s1, $zero, 4
	addi $s2, $zero, 4	
	addi $s3, $zero, 18
	jal drawing_line	# 29
	nop
	
	addi $s1, $zero, 5
	addi $s2, $zero, 4	
	addi $s3, $zero, 16	
	jal drawing_line	# 30
	nop
	
	addi $s1, $zero, 7
	addi $s2, $zero, 4	
	addi $s3, $zero, 12	
	jal drawing_line	# 31
	nop
	
	addi $s1, $zero, 8
	addi $s2, $zero, 6
	addi $s3, $zero, 6	
	jal drawing_line	# 32
	nop
	
	addi $s1, $zero, 10
	addi $s2, $zero, 7	
	addi $s3, $zero, 0	
	jal drawing_line	# 33
	nop
	
	addi $s1, $zero, 13
	addi $s2, $zero, 4	
	addi $s3, $zero, 0	
	jal drawing_line	# 34
	nop
	
	jr $t7
	nop
	
drawing_line:
	sll $t3, $s1, 2
	add $t0, $t0, $t3
	li $t2, 1
loop_draw_1:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	beq $t2, $s2, end_draw_1
	addi $t2, $t2, 1
	j loop_draw_1
end_draw_1:
	sll $t3, $s3, 2
	add $t0, $t0, $t3
	li $t2, 1
loop_draw_2:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	beq $t2, $s2, end_draw_2
	addi $t2, $t2, 1
	j loop_draw_2

#-------------------------------------------
#After drawing a line, it will return to the original starting position
#-------------------------------------------
end_draw_2:
	sll $t3, $s3, 2
	sub $t0, $t0, $t3
	sll $t3, $s2, 3
	sub $t0, $t0, $t3
	sll $t3, $s1, 2
	sub $t0, $t0, $t3
	add $t0, $t0, $s0
	jr $ra

# interrupt processing when a movie is received
.ktext 0x80000180
get_cause: 
    	mfc0 $t1, $13
    	
Is_keyboar_interrupt: 
    	li $t2, MASK_CAUSE_KEYBOARD
    	and $at, $t1, $t2
    	beq $at, $t2, Keyboard_Intr
other_cause:
	nop
	j end_process
	
Keyboard_Intr:
	nop
	lb $t3, 0($k0) #store the key in $t3
	addi $t6,$t3,0
	#Compare the printed film with the letters w,s,a,d
	beq $t3, 119, up_direction	# w
	beq $t3, 115, down_direction	# s
	beq $t3, 97, left_direction	# a
	beq $t3, 100, right_direction	# d
	
#--------------------------------------------------
# Assign characters to each corresponding number for easy processing
# w --> 1
# s --> 2
# a --> 3
# d --> 4
#--------------------------------------------------
	up_direction:
	addi $t9, $zero, 1
	jal check
	j end_process
	
	down_direction:
	addi $t9, $zero, 2
	jal check
	j end_process
	
	left_direction:
	addi $t9, $zero, 3
	jal check
	j end_process
	
	right_direction:
	addi $t9, $zero, 4
	jal check
	j end_process
	nop
	
end_process:
	mtc0 $zero, $13 	# reset nguyen nhan ngat
next_pc:
	mfc0 $at, $14 		# $at <= Coproc0.$14 = Coproc0.epc
	addi $at, $at, 4	# $at = $at + 4 (next instruction)
	mtc0 $at, $14 		# Coproc0.$14 = Coproc0.epc <= $at
return: 
	eret 
check:	
	li $t6,0
	li $a1,20
	jr $ra

