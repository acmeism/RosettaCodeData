# riscv assembly raspberry pico2 rp2350
# program binarysearch.s
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
szMessResult:       .asciz "Value found at index : "
szMessNotFound:     .asciz "Value not found. \r\n"

.align 2
TableNumber:        .int   -10,4,6,7,10,11,15,22,30,35
.equ NBELEMENTS1,   . - TableNumber
.equ NBELEMENTS,  NBELEMENTS1 / 4

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

    li a0,-10                  # find first value
    call testSearch
    li a0,35                    # find last value
    call testSearch
    li a0,10                    # find medium value
    call testSearch

    li a0,100                   # value not in array
    call testSearch
    li a0,-100                  # value not in array
    call testSearch


    la a0,szMessEnd
    call writeString
    call getchar
100:                           # final loop
    j 100b
/**********************************************/
/*   test   binary search                     */
/**********************************************/
/* a0    search value */
testSearch:                     # INFO: testSearch
    addi    sp, sp, -8         # reserve stack
    sw      ra, 0(sp)
    sw      s0,4(sp)
    mv s0,a0
    la a1,TableNumber
    li a2,NBELEMENTS
    call bsearch
    bltz a0,1f
    mv s0,a0
    la a0,szMessResult
    call writeString
    mv a0,s0
    la a1,sConvArea
    call conversion10
    la a0,sConvArea
    call writeString

    la a0,szCariageReturn
    call writeString
    j 100f
1:
    la a0,szMessNotFound
    call writeString
100:
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    addi    sp, sp, 8
    ret

/***************************************************/
/*   binary search */
/***************************************************/
/* a0 search  value           */
/* a1 array address */
/* a2 array size */
/* a0 return index or -1 if not find */
bsearch:                 # INFO: bsearch
    addi    sp, sp, -8   # save registres
    sw      ra, 0(sp)
    li t0,0              # low index
    addi t1,a2,-1        # high index N - 1
1:
    bgt t0,t1,99f        # not found
    add t2,t0,t1
    srli t2,t2,1         # compute (low+high)/ 2
    sh2add t3,t2,a1      # compute index address
    lw t4,(t3)           # load array value
    blt t4,a0,2f
    bgt t4,a0,3f
    mv a0,t2             # value found return index
    j 100f
2:                       # lower
    addi t0,t2,1         # low index = index + 1
    j 1b
3:                       # upper
    addi t1,t2,-1        # high index = index - 1
    j 1b
99:
    li a0,-1
100:
    lw      ra, 0(sp)
    addi    sp, sp, 8
    ret

/************************************/
/*     file include  Fonctions   */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../includeFunctions.s"
