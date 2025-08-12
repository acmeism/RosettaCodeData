# riscv assembly raspberry pico2 rp2350
# program arith.s
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
szMessAdd:           .asciz "Addition result :\r\n"
szMessSub:           .asciz "Substraction result :\r\n"
szMessMul:           .asciz "Multiplication result :\r\n"
szMessDiv:           .asciz "Division result :\r\n"
szMessRem:           .asciz "Division remainder :\r\n"
.align 2
#tabValues:      .int 1,2,3,4

/*******************************************/
/*  UNINITIALED DATA                    */
/*******************************************/
.bss
.align 2
sConvArea:       .skip 24

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
	
    la a0,szMessAdd            # addition
    call writeString           # display message
    li t0,10
    addi a0,t0,1               # add immediat number
    call displayResult
    li s0,15
    li s1,8
    add a0,s0,s1               # register add
    call displayResult

    la a0,szMessSub            # subtraction
    call writeString           # display message
    addi a0,s0,-6              # substract immediat number
    call displayResult
    sub a0,s0,s1               # substract register s1 to s0
    call displayResult

    la a0,szMessMul            # multiplication
    call writeString           # display message
    mul a0,s0,s1               # multiplication register
    call displayResult
    li s0,12345678
    li s1,23456789
    mul a0,s0,s1               # multiplication register
    call displayResult
    mulh a0,s0,s1              # Multiply signed (32) by signed (32), return upper 32 bits of the 64-bit result.
    call displayResult
    mulhsu a0,s0,s1            # Multiply signed (32) by unsigned (32), return upper 32 bits of the 64-bit result.
    call displayResult
    mulhu a0,s0,s1             # Multiply unsigned (32) by unsigned (32), return upper 32 bits of the 64-bit result.
    call displayResult

    la a0,szMessDiv            # division
    call writeString           # display message
    li s0,-25
    li s1,8
	div a0,s0,s1               # divide signed
	call displayResultS
	li s0,-25
    li s1,8
	divu a0,s0,s1              # Divide (unsigned)
	call displayResult
	
	la a0,szMessRem           # division
    call writeString           # display message
    li s0,-10
    li s1,8
	rem a0,s0,s1               # Remainder (signed).
	call displayResultS
	li s0,-10
    li s1,8
	remu a0,s0,s1               # Remainder (unsigned).
	call displayResult
	
    call getchar
100:                           # final loop
    j 100b

/**********************************************/
/*   display result unsigned                      */
/**********************************************/
/* a0    value */
.equ LGZONECONV,   20
displayResult:
    addi    sp, sp, -4         # reserve stack
    sw      ra, 0(sp)
    la a1,sConvArea            # conversion result address
    call conversion10          # conversion decimal
    la a0,sConvArea            # message address
    call writeString           # display message
    la a0,szCariageReturn
    call writeString
100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret
/**********************************************/
/*   displayResult  signed                     */
/**********************************************/
/* a0    value */
.equ LGZONECONV,   20
displayResultS:
    addi    sp, sp, -4         # reserve stack
    sw      ra, 0(sp)
    la a1,sConvArea            # conversion result address
    call conversion10S          # conversion decimal
    la a0,sConvArea            # message address
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
