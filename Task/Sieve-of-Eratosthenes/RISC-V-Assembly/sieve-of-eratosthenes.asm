# riscv assembly raspberry pico2 rp2350
# program cribleera.s
# connexion putty com3
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
/* for this file see risc-v task include a file */
.include "../../../constantesRiscv.inc"
.equ MAXI,          101
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
szMessNum:           .asciz "Prime : "

.align 2
/*******************************************/
/*  UNINITIALED DATA                    */
/*******************************************/
.bss
sConvArea:           .skip 24
.align 2
tablePrime:          .skip   4 * MAXI
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
	
	li s0,2                    # start indice
	la s2,tablePrime
	li s3,MAXI
	li s4,1
1:                             # loop for multiple of 2
    sh2add t0,s0,s2            # compute adresse of s0 index
	sw s4,(t0)                 # mark  multiple of 2
	addi s0,s0,2               # increment indice
	blt s0,s3,1b               # and loop if not maxi
	
    li s0,3                    # new start
	#li s4,1
2:
    sh2add t0,s0,s2            # compute adresse of s0 index
    lw 	t1,(t0)                # load mark
	bnez t1,4f                 # if not zero -> continue
	

    la a0,szMessNum            # else display prime
	call writeString
	mv a0,s0
    la a1,sConvArea
	call conversion10
	la a0,sConvArea
	call writeString
    la a0,szCariageReturn
	call writeString
	mv s1,s0                   # new prime
3:	                           # and loop to mark multiples of this prime
    sh2add t0,s1,s2            # compute adresse of s0 index
    sw 	s4,(t0)                # mark multiple
	add s1,s0,s1               # add the prime
	ble s1,s3,3b               # and loop if not maxi
4:	
    addi s0,s0,2               # increment indice
	ble s0,s3,2b               # and loop if not maxi

    la a0,szMessEndOk          # message address
    call writeString           # display message
    call getchar
100:                           # final loop
    j 100b

/************************************/
/*     file include  Fonctions      */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../../includeFunctions.s"
