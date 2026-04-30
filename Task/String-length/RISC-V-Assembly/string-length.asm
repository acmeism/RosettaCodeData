# riscv assembly raspberry pico2 rp2350
# program lenstring.s
# connexion putty com3
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
/* for this file see risc-v task include a file */
.include "../../constantesRiscv.inc"
.equ BUFFERSIZE,          255
/*******************************************/
/* INITIALED DATAS                    */
/*******************************************/
.data
szMessStart:         .asciz "Program riscv start.\r\n"
szMessEndOk:         .asciz "Program riscv end OK.\r\n"
szCariageReturn:     .asciz "\r\n"

szMessLenString:   .asciz "The lenght of string "
szMessLenString1:  .asciz " is "

szString1:           .asciz "Apple"
szString2:           .asciz "Orange"

.align 2
/*******************************************/
/*  UNINITIALED DATA                    */
/*******************************************/
.bss
sConvArea:   .skip 24
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
	

	la s0,szString1            # adresse string 1
	mv a0,s0
    call stringlength             # len string	
	la a1,sConvArea
	call conversion10          # call decimal conversion
	la a0,szMessLenString
    call writeString
	mv a0,s0
    call writeString
	la a0,szMessLenString1
    call writeString	
	la a0,sConvArea            # display result message
	call writeString
	la a0,szCariageReturn
    call writeString

	la s0,szString2            # adresse string 2
	mv a0,s0
    call stringlength             # len string	
	la a1,sConvArea
	call conversion10          # call decimal conversion
	la a0,szMessLenString
    call writeString
	mv a0,s0
    call writeString
	la a0,szMessLenString1
    call writeString	
	la a0,sConvArea            # display result message
	call writeString
	la a0,szCariageReturn
    call writeString

    la a0,szMessEndOk          # message address
    call writeString           # display message
    call getchar
100:                           # final loop
    j 100b
/***************************************************/
/*     compute string length               */
/***************************************************/
# a0 contains string e
# a0 return length
stringlength:
    addi    sp, sp, -4         # reserve stack
    sw      ra, 0(sp)          # save  registers              @ save  registers
    li t1,-1                   # init counter
1:                             # loop
    addi t1,t1,1               # increment counter
	add t0,a0,t1               # compute byte address
    lbu t2,(t0)                # load byte string
	bnez t2,1b                 # zero final ?
    mv a0,t1                   #return length
100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret

/************************************/
/*     file include  Fonctions   */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../includeFunctions.s"
