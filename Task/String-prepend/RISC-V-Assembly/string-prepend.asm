# riscv assembly raspberry pico2 rp2350
# program preendstring.s
# connexion putty com3
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
/* for this file see risc-v task include a file */
.include "../../constantesRiscv.inc"
.equ BUFFERSIZE,      100
/*******************************************/
/* INITIALED DATAS                    */
/*******************************************/
.data
szMessStart:         .asciz "Program riscv start.\r\n"
szMessEndOk:         .asciz "Program riscv end OK.\r\n"
szCariageReturn:     .asciz "\r\n"

szMessErrorString:   .asciz "Error buffer size."
szString:            .asciz "British Museum."
szStringPreend:      .asciz "The rosetta stone is at "

.align 2
/*******************************************/
/*  UNINITIALED DATA                    */
/*******************************************/
.bss
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
	
	la a0,szString
	call writeString           # display message
	la a0,szCariageReturn
	call writeString
	
	la a0,szString             # address  string 1
    la a1,szStringPreend       # address  string 2
	la a2,sBuffer              # result buffer
	li a3,BUFFERSIZE
    call preendString                #

	la a0,sBuffer              # result buffer
    call writeString           # display message
	la a0,szCariageReturn
	call writeString

    la a0,szMessEndOk          # message address
    call writeString           # display message
    call getchar
100:                           # final loop
    j 100b
/***************************************************/
/*    search string at beguining               */
/***************************************************/
# a0 contains string
# a1 contains search string
# a0 returns 1 if find or 0 if not or -1 if error
preendString:
    addi    sp, sp, -4         # reserve stack
    sw      ra, 0(sp)          # save  registers              @ save  registers
    li t1,0                    # init counter
	li t2,0
1:                             # copy string2 to result
	add t0,a1,t1               # compute byte address
    lbu t3,(t0)                # load byte string
	beqz t3,2f                 # zero final
	add t0,a2,t1               # compute byte address result
	sb t3,(t0)                 # store byte
	addi t1,t1,1
	bge t1,a3,99f
	j 1b
2:                             # copy string 1 to result
	add t0,a0,t2               # compute byte address
    lbu t3,(t0)                # load byte string
	add t0,a2,t1               # compute byte address result
	sb t3,(t0)                 # store byte
	beqz t3,3f                 # zero final
	addi t2,t2,1
	addi t1,t1,1
	bge t1,a3,99f
	j 2b
3:
    mv a0,t1                   # return total length	
	j 100f

99:                            # error
    la a0,szMessErrorString
	call writeString           # display message
	li a0,-1                   # error
100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret

/************************************/
/*     file include  Fonctions   */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../includeFunctions.s"
