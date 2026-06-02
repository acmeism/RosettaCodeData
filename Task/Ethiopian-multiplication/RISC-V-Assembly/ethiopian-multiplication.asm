# riscv assembly raspberry pico2 rp2350
# program multietiop.s
# connexion putty com3
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
/* for this file see risc-v task include a file */
.include "../../constantesRiscv.inc"

/****************************************************/
/* MACROS                   */
/****************************************************/
#.include "../ficmacrosriscv.inc"           # for debugging only

/*******************************************/
/* INITIALED DATAS                    */
/*******************************************/
.data
szMessStart:        .asciz "Program riscv start.\r\n"
szMessEnd:          .asciz "\nProgram end OK.\r\n"
szCariageReturn:    .asciz "\r\n"

szMessResult:       .asciz "Result : "

szMessErreur:       .asciz "Error overflow. \n"
.align 2
/*******************************************/
/*  UNINITIALED DATA                    */
/*******************************************/
.bss
.align 2
sConvArea:       .skip 24

/********************************...-..--*****/
/* SECTION CODE                              */
/**********************************************/
.text
.global main

main:                          # INFO: main
    call stdio_init_all        # général init
1:                             # start loop connexion
    li a0,0                    # raz argument register
    call tud_cdc_n_connected   # waiting for USB connection
    beqz a0,1b                 # return code = zero ?

    la a0,szMessStart          # message address
    call writeString           # display message

    li a0,17
    li a1,34
    call multEthiop
    la a1,sConvArea
    call conversion10
    la a0,szMessResult
    call writeString
    la a0,sConvArea
    call writeString
    la a0,szCariageReturn
    call writeString


    la a0,szMessEnd
    call writeString
    call getchar
100:                           # final loop
    j 100b

/******************************************************************/
/*     Ethiopian multiplication                                  */
/******************************************************************/
/*  a0 first factor */
/*  a1 2th  factor  */
/*  a0 return résult  */
multEthiop:                # INFO: multEthiop
    addi    sp, sp, -4    # reserve stack
    sw      ra, 0(sp)
    li t0,0                # init result
    li t1,1
1:
    blt a0,t1,3f
    andi t2,a0,1
    beqz t2,11f
    add t0,t0,a1            # add factor2 to result
11:
    srl a0,a0,1            # divide factor1 by 2
    sll t3,a1,1            # multiply factor2 by 2
    bltu t3,a1,2f          # overflow ?
    mv a1,t3
    j 1b                   # or loop
2:                         # error
    la a0,szMessErreur
    call writeString
    li t0,0
3:
    mv a0,t0

100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret
/************************************/
/*     file include  Fonctions   */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../includeFunctions.s"

