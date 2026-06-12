# riscv assembly raspberry pico2 rp2350
# program testrabinmuller.s
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
    call isPrimeMiller
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

/***************************************************/
/*   check if a number is prime  test miller rabin  */
/***************************************************/
/* a0 contains the number            */
/* a0 return 1 if prime  0 else */
isPrimeMiller:              # INFO: isPrimeMiller
    addi    sp, sp, -8      # save registres
    sw      ra, 0(sp)
    li t0,1
    bleu a0,t0,1f      # < 1
    li t0,2
    beq a0,t0,2f       # = 2
    andi t0,a0,1       # even ?
    beqz t0,1f
    li a1,5            # test loop
    call testMiller
    j 100f
1:
    li a0,0            # not prime
    j 100f
2:                     # prime
    li a0,1

100:
    lw      ra, 0(sp)
    addi    sp, sp, 8
    ret
/***************************************************/
/*   test miller rabin  algorithme wikipedia       */
/*   unsigned                                      */
/***************************************************/
/* a0 contains number   */
/* a1 contains parameter   */
/* a0 return 1 if prime 0 if composite    */
testMiller:                # INFO: testMiller
    addi    sp, sp, -28    # save registres
    sw      ra, 0(sp)
    sw      s0, 4(sp)
    sw      s1, 8(sp)
    sw      s2, 12(sp)
    sw      s3, 16(sp)
    sw      s4, 20(sp)
    sw      s5, 24(sp)
    mv s0,a0
    mv s1,a1
    addi s5,s0,-1          # D
    li t1,2
    li s4,0                # S
1:                         # compute D * 2 power S
    srli s5,s5,1           # D=D/2
    addi s4,s4,1           # increment S
    andi t3,s5,1           #  D even ?
    beqz t3,1b
2:
    li s2,0                # loop counter
3:
    addi a0,s0,-3
    call getRandom
    addi a0,a0,2           # alea (>2 <N-1)
    mv a1,s5               # exposant = D
    mv a2,s0               # modulo N
    call moduloPuR32
    li t3,1
    beq a0,t3,5f
    addi t3,s0,-1          # N - 1
    beq a0,t3,5f
    addi s3,s4,-1          # S - 1
4:
    mul t3,a0,a0
    mulhu a1,a0,a0         # compute square
    mv a0,t3
    mv a2,s0               # modulo N
    call division64by32
    mv a0,a2               # remainder
    li t3,1
    beq a0,t3,6f           # remainder = 1 -> composite
    addi t3,s0,-1          # N - 1
    beq a0,t3,5f
    addi s3,s3,-1          # decremente S-1
    bgez s3,4b             # and loop
    j 6f                   # composite
5:
    addi s2,s2,1
    blt s2,s1,3b           # and loop new test
    li a0,1                # prime
    j 100f
6:                         # composite
    li a0,0
    j 100f
100:
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    lw      s1, 8(sp)
    lw      s2, 12(sp)
    lw      s3, 16(sp)
    lw      s4, 20(sp)
    lw      s5, 24(sp)
    addi    sp, sp, 28
    ret

/***************************************************/
/*   division number 64 bits in 2 registers by number 32 bits */
/*   unsigned */
/***************************************************/
/* a0 contains lower part dividende   */
/* a1 contains upper part dividende   */
/* a2 contains divisor   */
/* a0 return lower part quotient    */
/* a1 return upper part quotient    */
/* a2 return remainder               */
/*correction dividende maxi ok  */
division64by32:     # INFO: division64by32
    addi    sp, sp, -8   # save registres
    sw      ra, 0(sp)
    beqz a2,99f     # divisor = 0 ?
    bnez a1,1f      # upper dividende = 0 ?
    mv t0,a0
    divu a0,t0,a2   # qotient 32 bits compute
    remu a2,t0,a2   # remainder compute
    j 100f
1:
    mv t0,a0        # copy lower dividende
    mv t1,a1        # copy upper dividende
    li a0,0         # init lower quotient
    li a1,0         # init upper quotient
    mv t2,a2        # init upper divisor with lower divisor
    li a2,0         # and init lower divisor
    li t3,32        # loop counter
2:
    slli a1,a1,1    # shift upper quotient
    slt t4,a0,x0    # bit 31 lower quotient
    or a1,a1,t4     # in bit 0 upper quotient
    slli a0,a0,1    # shift lower quotient
    mv a3,t0        # save lower dividende
    mv a4,t1        # save upper dividende
    sub t4,t0,a2    # compute lower dividende - lower divisor
    sgtu t5,t4,t0   # carry ?
    sub t6,t1,t2    # compute upper dividende - upper divisor
    bgtu t6,t1,3f   # overflow
    sub a5,t6,t5    # - carry
    bgtu a5,t6,3f   # overflow
    addi a0,a0,1    # soustraction ok increment quotient lower
    mv t0,t4        # move lower new dividende
    mv t1,a5        # move upper new dividende
    j 4f
3:                  # soustraction not possible restaur dividende
    mv t0,a3
    mv t1,a4
4:
    srli a2,a2,1    # shift divisor lower and upper divisor
    slli t4,t2,31
    or a2,a2,t4
    srli t2,t2,1
    addi t3,t3,-1   # decrement loop counter
    bgez t3,2b      # and loop

    mv a2,t0        # remainder

    j 100f
99:
    la a0,szMessDivby0
    call writeString
    j 100f

100:
    lw      ra, 0(sp)
    addi    sp, sp, 8
    ret

/********************************************************/
/*   Calcul modulo de b puissance e modulo m  */
/*    Exemple 4 puissance 13 modulo 497 = 445         */
/*                                             */
/********************************************************/
/* a0  nombre  */
/* a1 exposant */
/* a2 modulo   */
/* a0 return result  */
moduloPuR32:             # INFO:  moduloPuR32
    addi    sp, sp, -20  # save registres
    sw      ra, 0(sp)
    sw      s0, 4(sp)
    sw      s1, 8(sp)
    sw      s2, 12(sp)
    sw      s3, 16(sp)

    beqz a0,100f         # control <> zero
    beqz a2,100f
    mv s0,a0             # save base
    mv s1,a1             # save exposant
    mv s2,a2             # save modulo
    li s3,1              # init result
    li a1,0
    call division64by32  # division base by modulo
    mv s0,a2             # base <- remainder
2:
    andi t0,s1,1         # exposant even or odd
    beqz t0,3f

    mul a0,s0,s3         # base * result lower
    mulhu a1,s0,s3       # base * result upper
    mv a2,s2             #  and compute modulo N
    call division64by32
    mv s3,a2             # result <- remainder
3:
    mul a0,s0,s0         # base * result lower
    mulhu a1,s0,s0       # base * result upper
    mv a2,s2             #  and compute modulo N
    call division64by32
    mv s0,a2             # base <- remainder
    srli s1,s1,1         # exposant shift right 1b
    bnez s1,2b           # zero ?  no -> loop
    mv a0,s3             # else return result

100:
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    lw      s1, 8(sp)
    lw      s2, 12(sp)
    lw      s3, 16(sp)
    addi    sp, sp, 20
    ret
/**************************************/
/*       random generator            */
/***********************************/
.equ  TRNG_BASE,          0x400f0000
.equ  RND_SOURCE_ENABLE,  0x12c
.equ  RNG_ISR,            0x104
.equ TRNG_VALID,          0x110
.equ EHR_DATA0,           0x114
.equ EHR_DATA1,           0x118
/* a0 contains limit  */
getRandom:                       # INFO: getRandom
    addi    sp, sp, -8           # save registres
    sw      ra, 0(sp)
    beqz a0,100f
    li t0,1
    beq a0,t0,100f
    la t0,TRNG_BASE              # base address
    li t1,1
    sw t1,RND_SOURCE_ENABLE(t0)  # enable random

1:                               # loop attente ok
    lw t1,TRNG_VALID(t0)
    beqz t1,1b

    lw t2,EHR_DATA0(t0)          # begin random 32 bits
    remu a0, t2, a0              # remainder

    la t0,TRNG_BASE
    sw x0,RND_SOURCE_ENABLE(t0)  # Raz bit enable
100:
    lw      ra, 0(sp)
    addi    sp, sp, 8
    ret
/************************************/
/*     file include  Fonctions   */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../includeFunctions.s"

