# riscv assembly raspberry pico2 rp2350
# program loop1.s
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

szMessX:            .asciz "X"

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

main:
    call stdio_init_all        # général init
1:                             # start loop connexion
    li a0,0                    # raz argument register
    call tud_cdc_n_connected   # waiting for USB connection
    beqz a0,1b                 # return code = zero ?

    la a0,szMessStart          # message address
    call writeString           # display message
	
	li s0,0                    # counter loop 1
	li s2,5                    # maximun
1:	
	li s1,0                    # counter loop 2
2:
    la a0,szMessX
	call writeString           # display "X"
	addi s1,s1,1               # increment indice
	ble s1,s0,2b               # indice 2 <= indice 1 -> loop 2
	la a0,szCariageReturn      # else dispay CariageReturn
	call writeString
	addi s0,s0,1               # increment indice 1
	blt s0,s2,1b               # maxi ? no -> loop 1
	
	la a0,szMessEnd
	call writeString
    call getchar
100:                           # final loop
    j 100b

/************************************/
/*     file include  Fonctions   */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../includeFunctions.s"
