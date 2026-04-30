# riscv assembly raspberry pico2 rp2350
# program appstring.s
# connexion putty com3
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
/* for this file see risc-v task include a file */
.include "../../constantesRiscv.inc"
.equ BUFFERSIZE,          100
/*******************************************/
/* INITIALED DATAS                    */
/*******************************************/
.data
szMessStart:         .asciz "Program riscv start.\r\n"
szMessEndOk:         .asciz "Program riscv end OK.\r\n"
szCariageReturn:     .asciz "\r\n"

szMessString:            .asciz "String :\n"
szString1:              .asciz "Alphabet : "
sComplement:            .fill BUFFERSIZE,1,0
szString2:              .asciz "abcdefghijklmnopqrstuvwxyz"

.align 2
/*******************************************/
/*  UNINITIALED DATA                    */
/*******************************************/
.bss
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
	
	la a0,szMessString          # message address
    call writeString           # display message
	la a0,szString1          # message address
    call writeString           # display message	
	la a0,szCariageReturn          # message address
    call writeString           # display message
	
	la a0,szMessString          # message address
    call writeString           # display message
	la a0,szString2          # message address
    call writeString           # display message	
	la a0,szCariageReturn          # message address
    call writeString           # display message
	
	la a0,szString1
    la a1,szString2
    call append
	
	la a0,szMessString          # message address
    call writeString           # display message
	la a0,szString1          # message address
    call writeString           # display message	
	la a0,szCariageReturn          # message address
    call writeString           # display message

    la a0,szMessEndOk          # message address
    call writeString           # display message
    call getchar
100:                           # final loop
    j 100b

/*********************************************/
/* add string to string                      */
/*********************************************/
/* no verfication size complement buffer */
/* a0 contains address String 1           */
/* a1 contains address String 2         */
append:
    addi    sp, sp, -4
    sw      ra, 0(sp)
	li t0,0                    # counter byte string 1
1:
    add t1,a0,t0
    lbu t2,(t1)                 # load byte string 1
	beqz t2,2f                  # zero final ?
	addi t0,t0,1                # no -> increment counter
	j 1b                        # loop
2:	
    li t3, 0                    # counter byte string 2
3:
    add t4,a1,t3
    lbu t5,(t4)                 # load byte string 2
	add t1,a0,t0
	sb  t5,(t1)                 # store byte string 1
    beqz t5,100f                # zero final ? -> end
	addi t3,t3,1                # increment counter
	addi t0,t0,1
	j 3b                        # end loop

100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret


/************************************/
/*     file include  Fonctions   */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../includeFunctions.s"
