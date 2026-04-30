# riscv assembly raspberry pico2 rp2350
# program verifnumber.s
# connexion putty com3
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
/* for this file see risc-v task include a file */
.include "../../../constantesRiscv.inc"
.equ BUFFSIZE,      200
/****************************************************/
/* MACROS                   */
/****************************************************/
#.include "../ficmacrosriscv.inc"             # only for debugging
/*******************************************/
/* INITIALED DATAS                    */
/*******************************************/
.data
szMessStart:         .asciz "Program riscv start.\r\n"
szMessEndOk:         .asciz "Program riscv end OK.\r\n"
szCariageReturn:     .asciz "\r\n"
szMessNum:           .asciz "Enter number : \n"
szMessError:         .asciz "String is not a number !!!\n"
szMessInteger:       .asciz "String is a integer.\n"
szMessFloat:         .asciz "String is a float.\n"
szMessFloatExp:      .asciz "String is a float with exposant.\n"
szMessErreurBuf:     .asciz "Buffer size error."

.align 2
/*******************************************/
/*  UNINITIALED DATA                    */
/*******************************************/
.bss
sBuffer:           .skip BUFFSIZE
.align 2
/**********************************************/
/* SECTION CODE                              */
/**********************************************/
.text
.global main

main:
    call stdio_init_all        # général init
1:                             # start loop connexion
    li a0,0                    # raz argument register
    call tud_cdc_n_connected   # waiting for USB connection
    beqz a0,1b                 # return code = zero ? yes -> loop
	
    la a0,szMessStart          # message address
    call writeString           # display message
	
2:                             # loop begin
    la a0,szMessNum
	call writeString
    la a0,sBuffer
	li a1,BUFFSIZE
	call readString            # entry string
	la t0,sBuffer
	add t1,t0,a0
	sb x0,(t1)
    la a0,sBuffer
    call controlNumber         # control
    beqz a0,5f
	li t0,1
	bne a0,t0,3f
	la a0,szMessInteger
	call writeString	
	j 6f
3:	
	li t0,2
	bne a0,t0,4f
	la a0,szMessFloat
	call writeString	
	j 6f
4:	
	li t0,3
	bne a0,t0,5f
	la a0,szMessFloatExp
	call writeString	
	j 6f
5: 	
	la a0,szMessError
	call writeString
6:
	j 2b                       # and loop
 	
    la a0,szMessEndOk          # message address
    call writeString           # display message
    call getchar
100:                           # final loop
    j 100b
/**************************************************/
/*     saisie des commandes               */
/**************************************************/
/* a0 buffer address   */
/* a1 buffer size */
readString:                # INFO: readString
    addi    sp, sp, -16
    sw      ra, 0(sp)
    sw      s0, 4(sp)
    sw      s1, 8(sp)
    sw      s2, 12(sp)
    mv s0,a0               # buffer address
    li s1,0
    mv s2,a1               # buffer size
1:
    li a0,100
    call getchar           # character read
    beq a0,x0,2f           # zero ?
    li a1,0xD              # return carriage
    beq a0,a1,2f
    add t1,s0,s1           # compute address buffer
    sb a0,(t1)             # store character in buffer
    addi s1,s1,1           # increment indice
    bge s1,s2,99f
    call putchar           # write charactere for display in host
    j 1b                   # and loop

2:
    add s1,s0,s1
    sb x0,(s1)             # zero final

    li a0,0xA
    call putchar
    li a0,0xD
    call putchar
	mv a0,s0
    j 100f
99:                        # error
    la a0,szMessErreurBuf
    call writeString
    li a0,-1
100:
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    lw      s1, 8(sp)
    lw      s2, 12(sp)
    addi    sp, sp, 16
    ret
/******************************************************************/
/*     control if string is number                          */
/******************************************************************/
/* a0 contains the address of the string */
/* a0 return 0 if not a number       */
/* a0 return 1 if integer   eq 12345 or -12345      */
/* a0 return 2 if float     eq 123.45 or 123,45  or -123,45     */
/* a0 return 3 if float with exposant  eq 123.45E30 or -123,45E-30   or +123,45e+30     */
controlNumber:
    addi    sp, sp, -4
    sw      ra, 0(sp)

    li t1,0                   # string indice
    li t3,0                   # point or comma counter
	li t5,' '
2:
    add t4,a0,t1
	lbu t2,(t4)
	beqz t2,9f                # if end -> error
	bne t2,t5,3f
	addi t1,t1,1              # suppress spaces
	j 2b
3:
    li t5,'-'
    bne t2,t5,4f
    addi t1,t1,1              # negative
	j 5f
4:
	li t5,'+'
    bne t2,t5,5f
    addi t1,t1,1              # positive

5:
    add t4,a0,t1
	lbu t2,(t4)
	beqz t2,9f                # end ?
	bne t2,t5,6f
	addi t1,t1,1              # suppress space
	j 5b

6:
    add t4,a0,t1
	lbu t2,(t4)
	beqz t2,19f               # end ?
	li t5,'E'                 # exposant ?
	beq t2,t5,10f
	li t5,'e'                 # exposant ?
	beq t2,t5,10f
	li t5,'.'                 # point ?
	bne t2,t5,7f
	addi t3,t3,1              # yes increment counter
	addi t1,t1,1
	j 6b                      # and loop
7:
	li t5,','                 # comma ?
	bne t2,t5,8f	
	addi t3,t3,1              # yes increment counter
	addi t1,t1,1
	j 6b                      # and loop
8:
	li t5,'0'                 # control digit < 0
	blt t2,t5,9f
	li t5,'9'                 # control digit > 9
	bgt t2,t5,9f	
	addi t1,t1,1              # no error
	j 6b                      # and loop	

9:                            # error detected
    li a0,0
    j 100f
10:                           # float with exposant
    addi t1,t1,1
    add t4,a0,t1
	lbu t2,(t4)
	bnez t2,11f
    li a0,0                   # end -> error
    j 100f
11:
    li t5,'-'
    bne t2,t5,12f
	addi t1,t1,1              # negative exposant
	j 13f
12:
    li t5,'+'
    bne t2,t5,13f
	addi t1,t1,1              # positive exposant
13:
    li t6,0                   # digit counter
	
14:
    add t4,a0,t1
	lbu t2,(t4)
	beqz t2,16f               # end
	li t5,'0'                 # control digit < 0
	blt t2,t5,15f
	li t5,'9'                 # control digit > 9
	bgt t2,t5,15f
    addi t1,t1,1
    addi t6,t6,1              # increment counter digit
    j 14b   	              # and loop

15:                           # error
    li a0,0
	j 100f

16:
    bnez t6,17f
    li a0,0                   # number digit exposant = 0 -> error
	j 100f
17:
    li t5,2
    ble t6,t5,18f	          # number digit exposant > 2 -> error
    li a0,0
	j 100f 	
18:
    li a0,3                   # valid float with exposant
    j 100f 	
19:
    bnez t3,20f
	li a0,1                   #  valid integer
	j 100f
20:
    li t5,1
	bne t3,t5,21f             # number of point or comma = 1 ?
	li a0,2                   # valid float
	j 100f
21:
	li a0,0                   # error

100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret	

/************************************/
/*     file include  Fonctions      */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../../includeFunctions.s"
