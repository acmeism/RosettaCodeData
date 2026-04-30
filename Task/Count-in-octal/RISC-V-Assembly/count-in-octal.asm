# riscv assembly raspberry pico2 rp2350
# program cptoctal.s
# connexion putty com3
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
/* for this file see risc-v task include a file */
.include "../../../constantesRiscv.inc"
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
szMessResult:        .asciz "Octal = "       # message result


.align 2
/*******************************************/
/*  UNINITIALED DATA                    */
/*******************************************/
.bss
sConvArea:         .skip 24

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
	
    li s0,0                    # loop indice
	li s1,64
1:	
	mv a0,s0
    la a1,sConvArea
    call conversion8           # conversion octal


    la a0,szMessResult
    call writeString           # display message
	la a0,sConvArea
	call writeString
	la a0,szCariageReturn
	call writeString
	
	addi s0,s0,1
	ble s0,s1,1b
	

 	
    la a0,szMessEndOk          # message address
    call writeString           # display message
    call getchar
100:                           # final loop
    j 100b
/**************************************************/
/*     conversion octal                    */
/**************************************************/
.equ LGZONECAL,   10
/* a0 value               */
/* a1 conversion area     */
conversion8:                # INFO: conversion8
    addi    sp, sp, -4
    sw      ra, 0(sp)
    mv t3,a1
    li t2,LGZONECAL

1:                          # start loop
    mv t1,a0
    srli a0,a0,3            # / by 8
	slli t4,a0,3            # * by 8
	sub t1,t1,t4            # compute remainder t1 - (a0 * 8)
	addi t1,t1,48           # digit
    add t4,t3,t2
    sb t1,(t4)              # store digit on area
	beqz a0,2f              # stop if quotient = 0
	addi t2,t2,-1           # else previous position
	j 1b                    # and loop
2:
    li t1,0                 # and move digit from left of area
    li t5,LGZONECAL
3:
    add t4,t3,t2
	lbu t0,(t4)
	add t4,t3,t1
    sb  t0,(t4)
    addi t2,t2,1
    addi t1,t1,1
	ble t2,t5,3b
	add t4,t3,t1
    sb x0,(t4)              # zero final	
    mv a0,t1
	
100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret
/************************************/
/*     file include  Fonctions      */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../../includeFunctions.s"
