ackermann: 	#x: a1, y: a2, return: a0
beqz a1, npe #case m = 0
beqz a2, mme #case m > 0 & n = 0
addi sp, sp, -8 #case m > 0 & n > 0
sw ra, 4(sp)
sw a1, 0(sp)
addi a2, a2, -1
jal ackermann
lw a1, 0(sp)
addi a1, a1, -1
mv a2, a0
jal ackermann
lw t0, 4(sp)
addi sp, sp, 8
jr t0, 0
npe:
addi a0, a2, 1
jr ra, 0
mme:
addi sp, sp, -4
sw ra, 0(sp)
addi a1, a1, -1
li a2, 1
jal ackermann
lw t0, 0(sp)
addi sp, sp, 4
jr t0, 0
