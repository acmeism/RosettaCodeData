# riscv assembly raspberry pico2 rp2350
# program insstring.s
# connexion putty com3
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
/* for this file see risc-v task include a file */
.include "../../constantesRiscv.inc"
.equ BUFFERSIZE,          255
.equ CHARPOS,      '@'
/*******************************************/
/* INITIALED DATAS                    */
/*******************************************/
.data
szMessStart:         .asciz "Program riscv start.\r\n"
szMessEndOk:         .asciz "Program riscv end OK.\r\n"
szCariageReturn:     .asciz "\r\n"

szMessString:        .asciz "New string = "
szMessErrorSize:     .asciz "Error buffer size !"

szString:           .asciz " string "
szString1:          .asciz "insert"
szString2:          .asciz "abcd@efg"
szString3:          .asciz "abcdefg @"
szString4:          .asciz "@ abcdefg"

.align 2
/*******************************************/
/*  UNINITIALED DATA                    */
/*******************************************/
.bss
sConvArea:   .skip 24
sBuffer:     .skip BUFFERSIZE
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
    beqz a0,1b                 # return code = zero ?

    la a0,szMessStart          # message address
    call writeString           # display message
	
	la a0,szString             # string address
    la a1,szString1            # string address
	li a2,0
	la a3,sBuffer
	li a4,BUFFERSIZE
    call strInsert
	
	call displayResult
	
	la a0,szString             # string address
    la a1,szString1            # string address
	li a2,5
	la a3,sBuffer
	li a4,BUFFERSIZE
    call strInsert
	
	call displayResult
	
	la a0,szString             # string address
    la a1,szString1            # string address
	li a2,20
	la a3,sBuffer
	li a4,BUFFERSIZE
    call strInsert
	
	call displayResult

	la a0,szString2             # string address
    la a1,szString              # string address
	li a2,CHARPOS               # character insertion
	la a3,sBuffer
	li a4,BUFFERSIZE
    call strInsertAtChar
	
	call displayResult
	
	la a0,szString3             # string address
    la a1,szString              # string address
	li a2,CHARPOS               # character insertion
	la a3,sBuffer
	li a4,BUFFERSIZE
    call strInsertAtChar
	
	call displayResult
	
	la a0,szString4             # string address
    la a1,szString              # string address
	li a2,CHARPOS               # character insertion
	la a3,sBuffer
	li a4,BUFFERSIZE
    call strInsertAtChar
	
	call displayResult

    la a0,szMessEndOk          # message address
    call writeString           # display message
    call getchar
100:                           # final loop
    j 100b
/***************************************************/
/*    insertion string at position               */
/***************************************************/
# a0 contains string1
# a1 contains insert string
# a2 contains position
# a3 contains address buffer
# a4 contains buffer size
strInsert:
    addi    sp, sp, -4         # reserve stack
    sw      ra, 0(sp)          # save  registers              @ save  registers
    li t1,0                    # init counter
	li t3,0                    # init counter result string
1:                             # loop to copy string begin
    beq t1,a2,2f               # = position ?
	add t0,a0,t1               # compute byte address
    lbu t2,(t0)                # load byte string
	beqz t2,2f                 # zero final ? -> insertion at end
	add t0,a3,t3               # compute byte address
    sb t2,(t0)                 # store byte string
	addi t1,t1,1
	addi t3,t3,1
	bge t3,a4,99f              # error size ?
	j 1b                       # loop

2:
    li t4,0
3:
    add t0,a1,t4
	lbu t5,(t0)
	beqz t5,4f                 #end insertion string
	add t0,a3,t3               # compute byte address
    sb t5,(t0)
	addi t4,t4,1
	addi t3,t3,1
	bge t3,a4,99f              # error size ?
	j 3b                       # loop
4:
    beqz t2,6f                 # end string 1 ?
5:	
	add t0,a0,t1               # compute byte address
    lbu t2,(t0)                # load byte string
	beqz t2,6f                 # zero final ?
	add t0,a3,t3               # compute byte address
    sb t2,(t0)                 # store byte string
	addi t1,t1,1
	addi t3,t3,1
	bge t3,a4,99f              # error size ?
	j 5b                       # loop
6:	
    add t0,a3,t3               # compute byte address
    sb x0,(t0)                 # store zero final
    mv a0,t3                   #return length
	j 100f
99:
    la a0,szMessErrorSize
	call writeString           # display message
	li a0,-1                   # error
100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret
/***************************************************/
/*    insertion string at character insertion       */
/***************************************************/
# a0 contains string1
# a1 contains insert string
# a2 contains character insertion
# a3 contains address buffer
# a4 contains buffer size
 strInsertAtChar:
    addi    sp, sp, -4         # reserve stack
    sw      ra, 0(sp)          # save  registers              @ save  registers
    li t1,0                    # init counter
	li t3,0                    # init counter result string
1:                             # loop to copy string begin
	add t0,a0,t1               # compute byte address
    lbu t2,(t0)                # load byte string
	beqz t2,3f                 # zero final ? -> insertion at end
	beq t2,a2,2f               # character insertion
	add t0,a3,t3               # compute byte address
    sb t2,(t0)                 # store byte string
	addi t1,t1,1
	addi t3,t3,1
	bge t3,a4,99f              # error size ?
	j 1b                       # loop
2:
	addi t1,t1,1               # jump character insertion
3:
    li t4,0
4:
    add t0,a1,t4
	lbu t5,(t0)
	beqz t5,5f                 # end insertion string
	add t0,a3,t3               # compute byte address
    sb t5,(t0)
	addi t4,t4,1
	addi t3,t3,1
	bge t3,a4,99f              # error size ?
	j 4b                       # loop
5:
    beqz t2,7f                 # end string 1 ?
6:	
	add t0,a0,t1               # compute byte address
    lbu t2,(t0)                # load byte string
	beqz t2,7f                 # zero final ?
	add t0,a3,t3               # compute byte address
    sb t2,(t0)                 # store byte string
	addi t1,t1,1
	addi t3,t3,1
	bge t3,a4,99f              # error size ?
	j 6b                       # loop
7:	
    add t0,a3,t3               # compute byte address
    sb x0,(t0)                 # store zero final
    mv a0,t3                   #return length
	j 100f
99:
    la a0,szMessErrorSize
	call writeString           # display message
	li a0,-1                   # error
100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret
/***************************************************/
/*     display result string length               */
/***************************************************/
# a0 contains string e
# a0 return length
displayResult:
    addi    sp, sp, -4         # reserve stack
    sw      ra, 0(sp)          # save  registers              @ save  registers
	la a0,szMessString
    call writeString
	la a0,sBuffer
    call writeString
	la a0,szCariageReturn
    call writeString
100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret

/************************************/
/*     file include  Fonctions   */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../includeFunctions.s"
