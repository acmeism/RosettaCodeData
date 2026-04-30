# riscv assembly raspberry pico2 rp2350
# program primetrial.s
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

szMessPrime:          .asciz " is prime.\n"
szMessNotPrime:       .asciz " is not prime.\n"

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

    li a0,19
    call testPrime             #
    li s0,1
1:
    mv a0,s0
    call testPrime
    addi s0,s0,1
    li t0,30
    blt s0,t0,1b


    li a0,2600002183
    call testPrime             #

    li a0,4124163031
    call testPrime             #

    la a0,szMessEnd
    call writeString
    call getchar
100:                           # final loop
    j 100b
/**********************************************/
/*   prime traitement                     */
/**********************************************/
/* a0    value */
testPrime:                     # INFO: factorial
    addi    sp, sp, -8         # reserve stack
    sw      ra, 0(sp)
    sw      s0,4(sp)
    mv s0,a0
    la a1,sConvArea
    call conversion10
    la a0,sConvArea
    call writeString
    mv a0,s0
    call isPrime
    beqz a0,1f
    la a0,szMessPrime
    call writeString
    j 100f
1:
    la a0,szMessNotPrime
    call writeString

100:
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    addi    sp, sp, 8
    ret
/**********************************************/
/*   test  number is prime                     */
/**********************************************/
/* a0    value */
/* return 0 if not prime 1 else */
isPrime:              # INFO:isPrime
    addi    sp,sp, -4          # reserve stack
    sw      ra,0(sp)
    li t0,1
    bleu a0,t0,3f             # <= 1 ?
    li t0,3
    bleu a0,t0,4f             # 2 and 3 prime
    andi t0,a0,1
    beqz t0,3f                # even  not prime
    li t0,3                   # first divisor
1:
    remu  t1,a0,t0            # remainder
    beqz t1,3f                # if zero not prime
    addi t0,t0,2              # next divisor
    divu t1,a0,t0
    blt t1,t0,4f              # quotient < divisor -> prime
    j 1b                      # else loop

3:                            # not prime
    li a0,0
    j 100f
4:                            # prime
    li a0,1
100:
    lw      ra,0(sp)
    addi    sp,sp, 4
    ret
/************************************/
/*     file include  Fonctions   */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../includeFunctions.s"
