# riscv assembly raspberry pico2 rp2350
# program factor.s
# connexion putty com3
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
/* for this file see risc-v task include a file */
.include "../../constantesRiscv.inc"

.equ BUFFERSIZE,  80
/*******************************************/
/* INITIALIZED DATAS                    */
/*******************************************/
.data
szMessStart:         .asciz "Program riscv start.\r\n"
szMessEnd:           .asciz "\nProgram end OK.\r\n"
szCariageReturn:     .asciz "\r\n"
szMessNumber:        .asciz "Number :\r\n"
szMessFactor:        .asciz "Factors:\r\n"

.align 2

/*******************************************/
/*  UNINITIALIZED DATAS                    */
/*******************************************/
.bss
.align 2
sConvArea:       .skip 24
/***********************************...-..--***/
/* SECTION CODE                              */
/**********************************************/
.text
.global main                   # INFO: main

main:
    call stdio_init_all        # général init
1:                             # start loop connexion
    li a0,0                    # raz argument register
    call tud_cdc_n_connected   # waiting for USB connection
    beqz a0,1b                 # return code = zero ?

    la a0,szMessStart          # message address
    call writeString           # display message

    li a0,100
    call factors
	
	li a0,97
    call factors
	
	li a0,32767
	call factors

    la a0,szMessEnd
    call writeString
    call getchar
100:                           # final loop
    j 100b
/***************************************************/
/*      number display               */
/***************************************************/
# a0 contains number
# a0 return length
displayresult:
    addi    sp, sp, -4         # reserve stack
    sw      ra, 0(sp)          # save  registers
    la a1,sConvArea
    call conversion10S          # call decimal conversion
    la a0,sConvArea            # display result message
    call writeString
    la a0,szCariageReturn
    call writeString
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret
/******************************************************************/
/*     calcul factors of number                                  */
/******************************************************************/
/* a0 contains the number */
factors:
    addi    sp, sp, -8  # reserve stack
    sw      ra, 0(sp)   # save  registers
    sw      s0, 4(sp)
    mv s0,a0
    la a0,szMessNumber  # display title
    call writeString
	mv a0,s0
    call displayresult
    la a0,szMessFactor
    call writeString
	
    mv a0,s0            # number
    li s1,1             # counter loop
1:                      # loop
    rem t0,s0,s1
    bnez t0,2f          # remainder = zero ?
    mv a0,s1            # yes -> display factor
    call displayresult
2:
    addi s1,s1,1        # add 1 to loop counter
    ble s1,s0,1b        # <=  number ?

100:
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    addi    sp, sp, 8
    ret

/************************************/
/*     file include  Fonctions   */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../includeFunctions.s"
