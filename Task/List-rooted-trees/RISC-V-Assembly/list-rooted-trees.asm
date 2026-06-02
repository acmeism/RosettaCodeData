# riscv assembly raspberry pico2 rp2350
# program rootedtree.s   translation of C
# connexion putty com3
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
/* for this file see risc-v task include a file */
.include "../../constantesRiscv.inc"
.equ NBELEMENTS,      100              # list size
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

szMessResult:            .asciz "Number of trees :"
szParenOuv:              .asciz "("
szParenFer:              .asciz ")"

.align 2
offset:         .int 0,1           # 2 integers
                .fill 30,4,0       # 30 integers

.align 2
/*******************************************/
/*  UNINITIALED DATA                    */
/*******************************************/
.bss
.align 2
sConvArea:       .skip 24
lList1:       .skip 4 * NBELEMENTS    # list memory
iLen:         .skip 4
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

    li a0,0
    call append
    li s0,5                    # bags number
    mv a0,s0
    call mktrees               # build tree
    la a0,szMessResult
    call writeString
    la t0,offset
    sh2add t1,s0,t0
    lw t2,(t1)
    add t3,s0,1
    sh2add t1,t3,t0
    lw t3,(t1)
    sub a0,t3,t2
    la a1,sConvArea
    call conversion10
    la a0,sConvArea
    call writeString
    la a0,szCariageReturn
    call writeString

    mv a0,s0
    call displayTree

    la a0,szMessEnd
    call writeString
    call getchar
100:                           # final loop
    j 100b
/**********************************************/
/*   store value to list end                     */
/**********************************************/
/* a0  value */
append:                     # INFO: append
    addi    sp, sp, -8      # reserve stack
    sw      ra, 0(sp)
    sw      s0,4(sp)
    li t1,1
    sll t0,a0,1
    or t1,t1,t0
    la t0,lList1              # load list address
    la t2,iLen                # load counter address
    lw t3,(t2)                # load counter
    sh2add t4,t3,t0
    sw t1,(t4)
    addi t3,t3,1              # increment list counter
    sw t3,(t2)                # and store

100:
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    addi    sp, sp, 8
    ret
/**********************************************/
/*   store value to list end                     */
/**********************************************/
/* a0  bags number */
mktrees:                     # INFO: mktrees
    addi    sp, sp, -12      # reserve stack
    sw      ra, 0(sp)
    sw      s0,4(sp)
    sw      s1,8(sp)
    la s0,offset
    addi t0,a0,1
    sh2add  t1,t0,s0
    lw t2,(t1)               # load value n+1
    bnez t2,100f
    mv s1,a0
    beqz a0,2f
    addi a0,a0,-1
    call mktrees
2:
    mv a0,s1
    li a1,0
    addi a2,s1,-1
    sh2add  t1,a2,s0
    lw a3,(t1)               # load value n-1
    mv a4,a2
    call assemble
    la t0,iLen
    lw t1,(t0)
    addi t2,s1,1
    sh2add t3,t2,s0
    sw t1,(t3)

100:
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    lw      s1,8(sp)
    addi    sp, sp, 12
    ret
/******************************************************************/
/*     assemble tree                          */
/******************************************************************/
/* a0 contains bags number */
/* a1 contains list tree */
/* a2 contains  length of subtree   */
/* a3 contains offset of subtree */
/* a4 contains remaining length */
assemble:                    # INFO: assemble
    addi    sp, sp, -24      # reserve stack
    sw      ra, 0(sp)
    sw      s0,4(sp)
    sw      s1,8(sp)
    sw      s2,12(sp)
    sw      s3,16(sp)
    sw      s4,20(sp)
    bnez a4,1f              # remaining length is null
    mv a0,a1
    call append
    j 100f
1:
    mv s2,a2
    mv s3,a3
    mv s4,a0
    la t0,offset
    ble a2,a4,2f
    mv s2,a4
    sh2add t1,s2,t0
    lw s3,(t1)                # pos
    j 3f
2:
    addi t1,s2,1
    sh2add t2,t1,t0
    lw t3,(t2)
    blt s3,t3,3f
    addi s2,s2,-1
    beqz s2,100f              # end
    sh2add t1,s2,t0
    lw s3,(t1)                # pos
3:
    mv s0,a4
    mv s1,a1
    slli t1,s2,1
    sll t1,a1,t1
    la t2,lList1
    sh2add t3,s3,t2
    lw t3,(t3)
    or a1,t1,t3
    mv a2,s2
    mv a3,s3
    sub a4,a4,s2
    call assemble
    mv a0,s4
    mv a1,s1
    mv a2,s2
    addi a3,s3,1
    mv a4,s0
    call assemble

100:
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    lw      s1,8(sp)
    lw      s2,12(sp)
    lw      s3,16(sp)
    lw      s4,20(sp)
    addi    sp, sp, 24
    ret
/**********************************************/
/*   test   binary search                     */
/**********************************************/
/* a0    search value */
displayTree:                     # INFO: displayTree
    addi    sp, sp, -20         # reserve stack
    sw      ra, 0(sp)
    sw      s0,4(sp)
    sw      s1,8(sp)
    sw      s2,12(sp)
    sw      s3,16(sp)
    la t0,offset
    sh2add t1,a0,t0
    lw s3,(t1)
    addi t3,a0,1
    sh2add t1,t3,t0
    lw s2,(t1)
    la s0,lList1
    mv s1,a0
1:                                 # display solution loop
    bge s3,s2,100f
    sh2add a0,s3,s0
    lw a0,(a0)
    slli a1,s1,1
    call displayOne                # display one solution
    la a0,szCariageReturn
    call writeString
    addi s3,s3,1
    j 1b                           # and loop

100:
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    lw      s1,8(sp)
    lw      s2,12(sp)
    lw      s3,16(sp)
    addi    sp, sp, 20
    ret
/******************************************************************/
/*     display One solution                         */
/******************************************************************/
/* a0 contains one solution */
/* a1  length   */
displayOne:                    # INFO: displayOne
    addi    sp, sp, -12         # reserve stack
    sw      ra, 0(sp)
    sw      s0,4(sp)
    sw      s1,8(sp)
    mv s0,a0
    mv s1,a1
1:
    and t0,s0,1
    beqz t0,2f
    la a0,szParenOuv
    j 3f
2:
    la a0,szParenFer
3:
    call writeString
    srli s0,s0,1
    addi s1,s1,-1
    bgtz s1,1b

100:
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    lw      s1,8(sp)
    addi    sp, sp, 12
    ret

/************************************/
/*     file include  Fonctions   */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../includeFunctions.s"

