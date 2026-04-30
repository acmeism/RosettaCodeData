# riscv assembly raspberry pico2 rp2350
# program patiencesort.s
# connexion putty com3
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
/* for this file see risc-v task include a file */
.include "../../constantesRiscv.inc"
.equ HEAPSIZE,      50000
/****************************************************/
/* MACROS                   */
/****************************************************/
#.include "../ficmacrosriscv.inc"           # for debugging only

/*******************************************/
/* Structures                               */
/********************************************/
/* structure Doublylinkedlist*/
    .struct  0
dllist_head:                    # head node
    .struct  dllist_head + 4
dllist_tail:                    # tail node
    .struct  dllist_tail  + 4
dllist_end:
/* structure Node Doublylinked List*/
    .struct  0
NDlist_next:                    # next element
    .struct  NDlist_next + 4
NDlist_prev:                    # previous element
    .struct  NDlist_prev + 4
NDlist_value:                   # element value or key
    .struct  NDlist_value + 4
NDlist_end:

/*******************************************/
/* INITIALED DATAS                    */
/*******************************************/
.data
szMessStart:        .asciz "Program riscv start.\r\n"
szMessEnd:          .asciz "\nProgram end OK.\r\n"
szCariageReturn:    .asciz "\r\n"

szMessSortOk:       .asciz "Area sorted.\n"
szMessSortNok:      .asciz "Area not sorted !!!!!.\n"
szLibSort:          .asciz "\nAfter sort\n"
szSpace:            .asciz " "

.align 2
tabNumber:        .int 5,7,8,3,2,9,1,4,6
#tabNumber:        .int 9,8,7,6,5,4,3,2,1
.equ NBTABNUMBER1, . - tabNumber
.equ NBTABNUMBER, NBTABNUMBER1 / 4 # compute items number
ptHeapReserve:        .int heapReserve
/*******************************************/
/*  UNINITIALED DATA                    */
/*******************************************/
.bss
.align 2
sConvArea:       .skip 24

heapReserve:     .skip HEAPSIZE
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

    la s0,tabNumber            # number array address
    li s1,0
    li s2,NBTABNUMBER
2:                             # item loop
    sh2add t3,s1,s0            # compute item address
    lw a0,(t3)
    call displayResultD
    add s1,s1,1
    blt s1,s2,2b
    la a0,szCariageReturn
    call writeString
    mv a0,s0                   # number array address
    li a1,0                    # first item
    mv a2,s2
    call patienceSort          # sort
    mv a0,s0                   # number array address
    li a1,0                    # first item
    addi a2,s2,-1              # last item
    call isSorted

    la a0,szLibSort
    call writeString

    li s1,0
3:                             # item loop
    sh2add t3,s1,s0            # compute item address
    lw a0,(t3)
    call displayResultD
    add s1,s1,1
    blt s1,s2,3b
    la a0,szCariageReturn
    call writeString
    la a0,szMessEnd
    call writeString
    call getchar
100:                           # final loop
    j 100b
/**********************************************/
/*   display Result  décimal                     */
/**********************************************/
/* a0    value */
.equ LGZONECONV,   20
displayResultD:
    addi    sp, sp, -4         # reserve stack
    sw      ra, 0(sp)
    la a1,sConvArea            # conversion result address
    call conversion10          # binary conversion
    la a0,sConvArea            # message address
    call writeString           # display message
    la a0,szSpace
    call writeString
100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret

/**********************************************/
/*         sort control                */
/**********************************************/
/* a0 area address */
/* a1 first element */
/* a2 last element */
.equ LGZONECONV,   20
isSorted:
    addi    sp, sp, -4         # reserve stack
    sw      ra, 0(sp)
    mv t0,a1
    sh2add t1,t0,a0
    lw t2,(t1)                 # load first element
1:
    addi t0,t0,1
    ble t0,a2,2f               # end indice ?
    la a0,szMessSortOk
    call writeString
    li a0,1                    # yes -> area is sorted
    j 100f
2:
    sh2add t1,t0,a0
    lw t3,(t1)                 # load next element
    bge t3,t2,3f               # >=  ?
    la a0,szMessSortNok
    call writeString
    li a0,0                    # no -> area is not sorted
    j 100f
3:
    mv t2,t3
    j 1b
100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret

/******************************************************************/
/*         patience sort                                         */
/******************************************************************/
/* a0 contains array address */
/* a1 contains the first element    */
/* a2 contains the array size      */
patienceSort:
    addi    sp, sp, -48        # reserve stack
    sw      ra, 0(sp)          # save registers
    sw      s0, 4(sp)
    sw      s1, 8(sp)
    sw      s2, 12(sp)
    sw      s3, 16(sp)
    sw      s4, 20(sp)
    sw      s5, 24(sp)
    sw      s6, 28(sp)
    sw      s7, 32(sp)
    sw      s8, 36(sp)
    sw      s9, 40(sp)
    sw      s10, 44(sp)
    slli s0,a2,1
    slli s9,s0,3
    mv s2,a0                   # save table address
    mv s3,a2                   # save array size
    sub sp,sp,s9               # reserve on stacm
    mv s10,sp
    li s8,0
1:
    sh2add t0,s8,s10
    sw x0,(t0)                 # init piles area
    addi s8,s8,1               # increment index
    blt s8,s0,1b
    li s8,0                    # index value
    li s1,0                    # counter first pile
2:
    sh2add t0,s8,s2            # compute array address
    lw a1,(t0)                 # load value
    sh3add a0,s1,s10            # stack address
    lw t0,dllist_head(a0)
    bnez t0,3f                 # empty stack
    call insertHead            # insert value a1
    blez a0,100f
    j 5f

3:
    lw t5,dllist_head(a0)
    lw t5,NDlist_value(t5)     # load first list value
    blt a1,t5,4f
    call insertHead
    blez a0,100f
    j 5f
4:                             # value is smaller créate a new pile
    addi s1,s1,1
    sh3add a0,s1,s10            # new stack address
    call insertHead            # insert value r1
    blez a0,100f
5:
    addi s8,s8,1               # increment index value
    blt s8,s3,2b               # end ?  no -> loop
    li s7,0                    # init index value table
6:
    li s8,0                    # stack index
    li s5,1<<30                # minimum

7:                             # search minimum
    sh3add a0,s8,s10           # stack address
    lw a0,dllist_head(a0)
    beqz a0,8f                 # empty stack
    call searchMinList
    bge a0,s5,8f               # compare min global
    mv s5,a0                   # smaller -> store new min
    mv s4,a1                   # and pointer to min
    sh3add s6,s8,s10           #  and head list
8:
    addi s8,s8,1              # next stack
    ble s8,s1,7b              # end ? no -> loop
    sh2add t0,s7,s2
    sw s5,(t0)                # store min to table value
    mv a0,s6
    mv a1,s4
    call suppressNode
    addi s7,s7,1
    blt s7,s3,6b              # end ? no -> loop
100:
    add sp,sp,s9              # stack alignement
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    lw      s1, 8(sp)
    lw      s2, 12(sp)
    lw      s3, 16(sp)
    lw      s4, 20(sp)
    lw      s5, 24(sp)
    lw      s6, 28(sp)
    lw      s7, 32(sp)
    lw      s8, 36(sp)
    lw      s9, 40(sp)
    lw      s10, 44(sp)
    addi    sp, sp, 48
    ret

/**********************************************/
/* create new double linked list      */
/**********************************************/
/* a0 linked list address */
newDList:                      # INFO: newDList
    addi    sp, sp, -4
    sw      ra, 0(sp)

    sw x0,dllist_tail(a0)            # raz pointer
    sw x0,dllist_head(a0)            # raz pointer

    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret
/**********************************************/
/* insertion value in head       */
/**********************************************/
/* a0 double linked list address */
/* a1 contains the value of element  */
/* a0 returns address of element or - 1 if error */
insertHead:                      # INFO: insertTail
    addi    sp, sp, -8
    sw      ra, 0(sp)
    sw      s0, 4(sp)
    mv s0,a0                         # save address
    mv a0,a1                        # value
    call createNode                 # create new node
    blez a0,100f                    # error ?

    lw t0,dllist_head(s0)           # load address first node
    sw t0,NDlist_next(a0)           # store in next pointer on new node
    sw x0,NDlist_prev(a0)           # store null on prev pointer
    sw a0,dllist_head(s0)           # store address new node on list head
    beqz t0,1f                      # address last node is null ?
    sw a0,NDlist_prev(t0)           # no store address new node in next pointer
    j 2f
1:
    sw a0,dllist_tail(s0)           # else store in head list
2:

100:
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    addi    sp, sp, 8
    ret
/**********************************************/
/*             search value minimum       */
/**********************************************/
/* a0 contains the address of the list structure */
/* a0 return min           */
/* a1 return node address  */
searchMinList:                    # INFO: searchMinList
    addi    sp, sp, -4
    sw      ra, 0(sp)
    mv t0,a0
    li t3,1<<30
    li a1,0                       # init node address
1:
    bnez t0,2f                    # equal zero ?
    mv a0,t3                      # yes  -> end
    j 100f
2:
    lw t1,NDlist_value(t0)        # load node value
    bge t1,t3,3f                  # < ?
    mv t3,t1                      # yes -> min = new value
    mv a1,t0
3:
    lw t0,NDlist_next(t0)         # load address next node
    j 1b                          # and loop

100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret
/**********************************************/
/*  create node on heap                       */
/**********************************************/
/* a0 value */
/* a0 return node address or -1 if error */
createNode:                      # INFO: createNode
    addi    sp, sp, -4
    sw      ra, 0(sp)
    la t0,ptHeapReserve
    lw t1,(t0)                  # free heap address
    addi t2,t1,NDlist_end       # reserve area on heap
    la t3,heapReserve
    li t4,HEAPSIZE
    add t3,t3,t4
    blt t2,t3,2f
    li a0,-1
    j 100f
2:
    sw t2,(t0)                  # save new value heap used
    sw a0,NDlist_value(t1)      # store value on heap
    sw x0,NDlist_next(t1)       # raz pointer next
    sw x0,NDlist_prev(t1)       # raz pointer previous
    mv a0,t1                    # return node address
100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret
/**********************************************/
/*  suppress node on list                       */
/**********************************************/
/* a0 contains the address of the list structure */
/* a1 contains the address to node to suppress */
suppressNode:                      # INFO: suppressNode
    addi    sp, sp, -4
    sw      ra, 0(sp)
    lw t0,NDlist_next(a1)          # load addresse next node
    lw t1,NDlist_prev(a1)          # load addresse prev node
    beqz t1,1f
    sw t0,NDlist_next(t1)
    j 2f
1:
    sw t1,NDlist_next(a0)
2:
    beqz t0,3f
    sw t1,NDlist_prev(t0)
    j 100f
3:
    sw t0,NDlist_prev(a0)
100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret
/************************************/
/*     file include  Fonctions   */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../includeFunctions.s"
