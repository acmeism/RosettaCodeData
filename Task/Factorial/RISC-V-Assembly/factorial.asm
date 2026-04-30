# riscv assembly raspberry pico2 rp2350
# program factorial.s
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

szMessLargeNumber:   .asciz "Number N to large. \n"
szMessNegNumber:     .asciz "Number N is negative. \n"

szMessResult:  .ascii "Resultat = "      # message result

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

    li a0,-10
    call factorial             #
    li a0,0
    call factorial             #
    li a0,10
    call factorial             #

    la a0,szMessEnd
    call writeString
    call getchar
100:                           # final loop
    j 100b
/**********************************************/
/*   compute factorial                     */
/**********************************************/
/* a0    value */
factorial:                     # INFO: factorial
    addi    sp, sp, -4         # reserve stack
    sw      ra, 0(sp)
    bltz a0,99f                # is negative ?
    li t0,1
    ble a0,t0,1f               # is 0 or 1
    call computeFactorial
    li t0,-1                   # error overflow ?
    beq a0,t0,98f
1:                             # display result
    la a1,sConvArea
    call conversion10
    la a0,szMessResult
    call writeString
    la a0,sConvArea
    call writeString
    la a0,szCariageReturn
    call writeString
    j 100f
98:
    la a0,szMessLargeNumber
    call writeString
    j 100f
99:
    la a0,szMessNegNumber
    call writeString
    j 100f
100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret
/**********************************************/
/*   compute factorial                     */
/**********************************************/
/* a0    value */
computeFactorial:              # INFO:computeFactorial
    addi    sp,sp, -8          # reserve stack
    sw      ra,0(sp)
    sw      s0,4(sp)
    li t0,1
    beq a0,t0,100f             # if n = 1 return
    mv s0,a0
    addi a0,a0,-1
    call computeFactorial
    li t0,-1                   # error overflow ?
    beq a0,t0,100f
    mulh t0,a0,s0              # compute half high 32 bits
    beqz t0,1f                 # is ok if result is zero
    li a0,-1                   # error overflow
    j 100f
1:
    mul a0,a0,s0               # multiplication
100:
    lw      ra,0(sp)
    lw      s0,4(sp)
    addi    sp,sp, 8
    ret
/************************************/
/*     file include  Fonctions   */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../includeFunctions.s"
