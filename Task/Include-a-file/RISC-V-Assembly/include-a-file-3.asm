# riscv assembly raspberry pico2 rp2350
# program include.s
# connexion putty com3
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
.include "../../constantesRiscv.inc"

/*******************************************/
/* INITIALED DATAS                    */
/*******************************************/
.data
szMessHello:         .asciz "Hello world.\r\n"
szMessStart:         .asciz "Program riscv start.\r\n"

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
    call tud_cdc_n_connected
    beqz a0,1b                 # retuen code = zero ?

    la a0,szMessStart          # message address
    call writeString           # display message
    la a0,szMessHello          # message address
    call writeString           # display message

100:                           # final loop
    j 100b
/************************************/
/*     file include  Fonctions   */
/***********************************/
.include "../../includeFunctions.s"
