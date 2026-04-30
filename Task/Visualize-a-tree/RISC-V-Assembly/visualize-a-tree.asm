# riscv assembly raspberry pico2 rp2350
# program displaytree.s
# connexion putty com3
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
/* for this file see risc-v task include a file */
.include "../../constantesRiscv.inc"
.equ HEAPSIZE,   50000
.equ NBVAL,      9

/****************************************************/
/* MACROS                   */
/****************************************************/
#.include "../ficmacrosriscv.inc"           # for debugging only

/*******************************************/
/* Structures                               */
/********************************************/
/* structure tree     */
    .struct  0
tree_root:                             # root pointer
    .struct  tree_root + 4
tree_size:                             # number of element of tree
    .struct  tree_size + 4
tree_fin:
/* structure node tree */
    .struct  0
node_left:                             # left pointer
    .struct  node_left + 4
node_right:                            # right pointer
    .struct  node_right + 4
node_value:                            # element value
    .struct  node_value + 4
node_fin:


/*******************************************/
/* INITIALED DATAS                    */
/*******************************************/
.data
szMessStart:        .asciz "Program riscv start.\r\n"
szMessEnd:          .asciz "\nProgram end OK.\r\n"
szCariageReturn:    .asciz "\r\n"
szIndent:           .asciz "|-->"
szIndent1:          .asciz "|   "

szMessDisplayTree:        .asciz "Tree display :\n"

szMessResult:       .asciz "Element value : "
.align 2
ptHeapReserve:        .int heapReserve


.align 2
/*******************************************/
/*  UNINITIALED DATA                    */
/*******************************************/
.bss
.align 2
sConvArea:       .skip 24
stTree:          .skip tree_fin    # place to structure tree
heapReserve:     .skip HEAPSIZE
/********************************...-..--*****/
/* SECTION CODE                              */
/**********************************************/
.text
.global main

main:                          # INFO: main
    call stdio_init_all        # général init
1:                             # start loop connexion
    li a0,0                    # raz argument register
    call tud_cdc_n_connected   # waiting for USB connection
    beqz a0,1b                 # return code = zero ?

    la a0,szMessStart          # message address
    call writeString           # display message
    li s0,1
1:
    la a0,stTree
    mv a1,s0                   # value
    call insertElement
    li t0,-1
    beq a0,t0,100f
    addi s0,s0,1
    li t0,NBVAL
    ble s0,t0,1b

    la a0,szMessDisplayTree
    call writeString

    la a0,stTree
    lw a0,tree_root(a0)
    li a1,0
    call displayTree

    la a0,szMessEnd
    call writeString
    call getchar
100:                           # final loop
    j 100b
/******************************************************************/
/*     insert element in the tree                                 */
/******************************************************************/
/* a0 contains the address of the tree structure */
/* a1 contains the value of element              */
/* a0 returns address of element or - 1 if error */
insertElement:                      # INFO: insertElement
    addi    sp, sp, -8              # save registres
    sw      ra, 0(sp)
    sw      s0,4(sp)
    mv s0,a0
    li a0,node_fin                  # reservation place one element
    call allocHeap
    li t0,-1
    beq a0,t0,100f                  # allocation error
    mv t0,a0                        # save address
    sw a1,node_value(t0)            # store value in address heap
    sw x0,node_left(t0)             # init left pointer with zero
    sw x0,node_right(t0)            # init right pointer with zero
    lw t1,tree_size(s0)             # load tree size
    bnez t1,1f                      # 0 element
    sw t0,tree_root(s0)             # yes -> store in root
    j 4f
1:                                  # else search free address in tree
    lw t2,tree_root(s0)             # start with address root
    mv t5,a1                        # value node
    clz t3,t5                       # compute zeroes left bits
    addi t3,t3,1                    # for sustract the first left bit
    sll t5,t5,t3                    # shift number in left
2:
    slt t4,t5,x0                    # is bit31 = 1
    slli t5,t5,1
    bnez t4,3f                      # is bit31 = 1
    lw t4,node_left(t2)             # no store node address in left pointer
    bnez t4,21f                     # equal zero ?
    sw t0,node_left(t2)
    j 4f
21:
    mv t2,t4                        # else loop with next node
    j 2b
3:
    lw t4,node_right(t2)            # no store node address in right pointer
    bnez t4,31f                     # equal zero ?
    sw t0,node_right(t2)
    j 4f
31:
    mv t2,t4                        # else loop with next node
    j 2b                            # and loop
4:
    addi t1,t1,1
    sw t1,tree_size(s0)
    mv a0,t0

100:
    lw      ra, 0(sp)
    lw      s0,4(sp)
    addi    sp, sp, 8
    ret
/******************************************************************/
/*     display node                                               */
/******************************************************************/
/* a0 contains node  address          */
displayElement:                # INFO: displayElement
    addi    sp, sp, -8         # reserve stack
    sw      ra, 0(sp)
    sw      s0,4(sp)
    lw a0,node_value(a0)
    la a1,sConvArea
    call conversion10S
    la a0,szMessResult
    call writeString
    la a0,sConvArea
    call writeString
    la a0,szCariageReturn
    call writeString
100:
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    addi    sp, sp, 8
    ret
/******************************************************************/
/*    Display tree                                  */
/******************************************************************/
/* a0 contains tree address */
/* a1 level    */
/* a0 returns 0 if empty else 1  */
displayTree:             # INFO: displayTree
    addi    sp, sp, -20    # reserve stack
    sw      ra, 0(sp)
    sw      s0, 4(sp)
    sw      s1, 8(sp)
    sw      s2, 12(sp)
    sw      s3, 16(sp)
    li t0,-1
    beq a0,t0,100f
    mv s0,a0
    mv s1,a1
    li s2,0
    la s3,szIndent1
1:                     # display indentation loop
    bge s2,s1,2f
    mv a0,s3
    call writeString
    addi s2,s2,1
    j 1b
2:
    la a0,szIndent
     call writeString
   # affregtit debut1
    lw a0,node_value(s0)
    la a1,sConvArea
    call conversion10S
    la a0,sConvArea
    call writeString
    la a0,szCariageReturn
    call writeString

    lw a0,node_left(s0)
    beqz a0,3f
    addi a1,s1,1
    call displayTree
3:
    lw a0,node_right(s0)
    beqz a0,4f
    addi a1,s1,1
    call displayTree
    j 100f
4:
    li a0,-1

100:
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    lw      s1, 8(sp)
    lw      s2, 12(sp)
    lw      s3, 16(sp)
    addi    sp, sp, 20
/******************************************************************/
/*     memory allocation on the heap                                  */
/******************************************************************/
/* a0 contains the size to allocate */
/* a0 returns address of memory heap or - 1 if error */
/* CAUTION : The size of the allowance must be a multiple of 4  */
allocHeap:                # INFO: allocHeap
    addi    sp, sp, -8    # reserve stack
    sw      ra, 0(sp)
    la t0,ptHeapReserve
    lw t1,(t0)             # free heap address
    add t2,t1,a0          # reserve area on heap
    la t3,heapReserve
    li t4,HEAPSIZE
    add t3,t3,t4           # compute heap end
    blt t2,t3,1f           # allocation address < heap end ?
    li a0,-1               # allocation error
    j 100f
1:
    sw t2,(t0)             # store new start free address heap
    mv a0,t1               # return address
100:
    lw      ra, 0(sp)
    addi    sp, sp, 8
    ret

/************************************/
/*     file include  Fonctions   */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../includeFunctions.s"
