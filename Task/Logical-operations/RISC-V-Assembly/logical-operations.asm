# riscv assembly raspberry pico2 rp2350
# program operlog.s
# connexion putty com3
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
/* for this file see risc-v task include a file */
.include "../../constantesRiscv.inc"

/*******************************************/
/* INITIALED DATAS                    */
/*******************************************/
.data
szMessStart:         .asciz "Program riscv start.\r\n"
szCariageReturn:     .asciz "\r\n"
szMessReg0:          .asciz "Register s0:\r\n"
szMessReg1:          .asciz "Register s1:\r\n"
szMessAnd:           .asciz "And result:\r\n"
szMessOr:            .asciz "Or result :\r\n"
szMessXor:           .asciz "Xor result :\r\n"
szMessNot:           .asciz "Not result :\r\n"
szMessNeg:           .asciz "Neg result :\r\n"

.align 2

/*******************************************/
/*  UNINITIALED DATA                    */
/*******************************************/
.bss
.align 2
sConvArea:       .skip 24
sConvBinaire:    .skip 36
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
	
	la a0,szMessReg0           # message address
    call writeString           # display message
	li s0,0b1100
	mv a0,s0
	call displayResult
	
    la a0,szMessReg1           # message address
    call writeString           # display message
	li s1,0b1001
	mv a0,s1
    call displayResult
	
    la a0,szMessAnd            # and
    call writeString           # display message
    andi a0,s0,0b1001          # and immediat value
    call displayResult
    and a0,s0,s1               # register and
    call displayResult
	andn a0,s0,s1              # register and and not
    call displayResult

    la a0,szMessOr             # or
    call writeString           # display message
    ori a0,s0,0b1001           # or immediat value
    call displayResult
    or a0,s0,s1                # or register
    call displayResult
    orn a0,s0,s1               # or and not register
    call displayResult
	orc.b a0,s0                # OR-combine of bits within each byte. Generates a mask of nonzero bytes
    call displayResult
	
	
    la a0,szMessXor            # xor
    call writeString           # display message
    xori a0,s0,0b1001          # xor immediat value
    call displayResult
    xor a0,s0,s1               # xor register
    call displayResult
	xnor a0,s0,s1              # Bitwise XOR with inverted operand. Equivalently, bitwise NOT of bitwise XOR
    call displayResult

    la a0,szMessNot            # not
    call writeString           # display message
	not a0,s0                  # not
	call displayResult
	
	la a0,szMessNeg            # negation
    call writeString           # display message
	neg a0,s0                  # negation
	call displayResult
	

    call getchar
100:                           # final loop
    j 100b

/**********************************************/
/*   display binary Result                       */
/**********************************************/
/* a0    value */
.equ LGZONECONV,   20
displayResult:
    addi    sp, sp, -4         # reserve stack
    sw      ra, 0(sp)
    la a1,sConvBinaire         # conversion result address
    call conversion2           # binary conversion
    la a0,sConvBinaire         # message address
    call writeString           # display message
    la a0,szCariageReturn
    call writeString
100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret
	
/************************************/
/*     file include  Fonctions   */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../includeFunctions.s"
