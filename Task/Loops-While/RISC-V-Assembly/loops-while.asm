# riscv assembly raspberry pico2 rp2350
# program loopwhile1.s
# connexion putty com3
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
/* for this file see risc-v task include a file */
.include "../../../constantesRiscv.inc"
/*******************************************/
/* INITIALED DATAS                    */
/*******************************************/
.data
szMessStart:         .asciz "Program riscv start.\r\n"
szMessEndOk:         .asciz "Program riscv end OK.\r\n"
szCariageReturn:     .asciz "\r\n"
szMessResult:        .asciz "Counter = "       # message result


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
	
	li s0,1024
1:
    mv a0,s0
    la a1,sConvArea            # conversion area
    call conversion10          # conversion décimale

    la a0,szMessResult
    call writeString           # display message
	la a0,sConvArea
	call writeString
	la a0,szCariageReturn
	call writeString
    srli s0,s0,1               # division by 2
	bgtz s0,1b                 # >= zero -> loop
 	
    la a0,szMessEndOk          # message address
    call writeString           # display message
    call getchar
100:                           # final loop
    j 100b

/************************************/
/*     file include  Fonctions   */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../../includeFunctions.s"
