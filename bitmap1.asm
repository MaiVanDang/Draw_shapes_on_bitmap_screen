#Dia chi bat dau cua bo nho man hinh
.eqv MONITOR_SCREEN 0x10010000 

#Dia chi bat dau MMIO
.eqv KEY_CODE 0xFFFF0004
.eqv KEY_READY 0xFFFF0000 
#Danh sach mau
.eqv YELLOW 0x00FFFF00
.eqv BLACK 0x00000000
#---------------------------------
.eqv MASK_CAUSE_KEYBOARD 0x0000034 

.text
# Thiet lap vi tri ban dau cua qua cau o trung tam
	li $t0, MONITOR_SCREEN #Nap dia chi bat dau cua man hinh
	addi $s0, $zero, 2048 # offset 1 line 512*4
	addi $t3, $zero, 235
	
	li $k0, KEY_CODE
	li $k1, KEY_READY

	mult $s0, $t3
	mflo $t4
	add $t0, $t0, $t4
	
	sll $t4, $t3, 2
	add $t0, $t0, $t4	#Xac dinh vi tri bat dau

	addi $s4, $zero, 236	# xA
	addi $s5, $zero, 236	# yA
	addi $s6, $zero, 269	# xB
	addi $s7, $zero, 269	# yB
#Ve hinh tron
	add $t8, $t0, 0
	li $t1, YELLOW
	jal drawing_circle
	
	addi $t9, $zero, 0	# Huong di chuyen (1, 2, 3, 4) = (len, xuong, trai, phai)
	li $a1, 100
moving:
	addi $t6,$t9,0	# Luu huong dang chay
	addi $a0,$a1,0	#sleep
	li $v0, 32
	syscall
	nop
	
	lw $t1, 0($k1) 
	beq $t1, $zero, continue
	MakeIntR: 	# Kich hoat ngat mem khi nhan duoc phim
	teqi $t1, 1
	
	continue:
	beq $t9, 1, up
	beq $t9, 2, down
	beq $t9, 3, left
	beq $t9, 4, right
	nop
	j moving
	
	up:
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
	addi $s1, $zero, 13	# so pixel trong o dau
	addi $s2, $zero, 4	# so pixel can ve
	addi $s3, $zero, 0	# so pixel trong o giua
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
#Sau khi ve xong 1 dong thi se tra lai ve vi tri ban dau xuat phat ve
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

# Xu ly ngat khi co phim duoc nhan
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
	lb $t3, 0($k0) #luu ki tu duoc an vao $t3
	#Doi chieu phim duoc an voi cac ki tu w,s,a,d
	beq $t3, 119, up_direction	# w
	beq $t3, 115, down_direction	# s
	beq $t3, 97, left_direction	# a
	beq $t3, 100, right_direction	# d
	
#--------------------------------------------------
# Gan cac ki tu voi tung so tuong ung de de xu ly
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
	beq $t6,$t9,set_time
	li $a1,100
	jr $ra
set_time:
	beq $a1,0,else
	sub $a1,$a1,20
else:
	jr $ra
