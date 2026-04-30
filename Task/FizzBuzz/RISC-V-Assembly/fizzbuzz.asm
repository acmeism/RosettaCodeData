# riscv assembly raspberry pico2 rp2350
# program fizzbuzz.s
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
szMessFizz:          .asciz " Fizz\n"
szMessBuzz:          .asciz " Buzz\n"
szMessFizzBuzz:      .asciz " FizzBuzz\n"


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
	li s1,3                    # divisor 3
	li s2,5                    # divisor 5
	li s3,15                   # divisor 15
	li s4,100
1:	
    remu t0,s0,s3              # / by 15
	bnez t0,2f
    la s5,szMessFizzBuzz
	j 4f
2:	
    remu t0,s0,s2              # / by 5
	bnez t0,3f
    la s5,szMessBuzz
	j 4f	
3:	
    remu t0,s0,s1              # / by 3
	bnez t0,5f
    la s5,szMessFizz
	j 4f
	
4:	
	mv a0,s0
    la a1,sConvArea
    call conversion10           # conversion decimal

	la a0,sConvArea
	call writeString
	#la a0,szCariageReturn
	#call writeString
	mv a0,s5
    call writeString           # display message
5:
	addi s0,s0,1
	ble s0,s4,1b
	

 	
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
