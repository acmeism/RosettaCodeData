# riscv assembly raspberry pico2 rp2350
# program heapsort.s
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

szMessSortOk:       .asciz "Area sorted.\n"
szMessSortNok:      .asciz "Area not sorted !!!!!.\n"
szLibSort:          .asciz "\nAfter sort\n"
szSpace:            .asciz " "

.align 2
tabNumber:        .int 5,7,8,3,2,9,1,4,6
#tabNumber:        .int 9,8,7,6,5,4,3,2,1
.equ NBTABNUMBER1, . - tabNumber
.equ NBTABNUMBER, NBTABNUMBER1 / 4 # compute items number

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

    la s0,tabNumber            # number array address
	li s1,NBTABNUMBER
	li s2,0
2:                             # item loop
    sh2add t3,s2,s0            # compute item address
	lw a0,(t3)
	call displayResultD
	add s2,s2,1
	blt s2,s1,2b	
    la a0,szCariageReturn
    call writeString
	mv a0,s0                   # array address
	mv a1,s1                   # array size
	call heapSort              # sort
	mv a0,s0                   # number array address
	mv a1,s1                 # array size
	call isSorted
	
	la a0,szLibSort
	call writeString

	li s2,0
3:                             # item loop
    sh2add t3,s2,s0            # compute item address
	lw a0,(t3)
	call displayResultD
	add s2,s2,1
	blt s2,s1,3b
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
/* a0 array address */
/* a1 array size  */
.equ LGZONECONV,   20
isSorted:
    addi    sp, sp, -4         # reserve stack
    sw      ra, 0(sp)
	li t0,0
	sh2add t1,t0,a0
	lw t2,(t1)                 # load first element
1:
    addi t0,t0,1
    blt t0,a1,2f               # end indice ?
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
/*         merge sort                                         */
/******************************************************************/
/* a0 contains array address */
/* a1 contains array size     */
heapSort:
    addi    sp, sp, -8        # reserve stack
    sw      ra, 0(sp)          # save registers
	sw      s0, 4(sp)
	mv s0,a1
	addi s0,s0,-1              # last element
	call heapify               # first place table in max-heap order
1:
	blez s0,100f
	li a1,0                    #
	mv a2,s0
	call swapElement
	addi s0,s0,-1              # decrement indice
	li a1,0                   #
	mv a2,s0
	call siftDown
	j 1b
	
100:
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    addi    sp, sp, 8
    ret
/******************************************************************/
/*          place array in max-heap order                         */
/******************************************************************/
/* a0 contains array address  */
/* a1 element number  */

heapify:                       # INFO: heapify
    addi    sp, sp, -12        # reserve stack
    sw      ra, 0(sp)          # save registers	
	sw      s0, 4(sp)
	sw      s1, 8(sp)
	mv s0,a1                   # init
	addi t1,a1,-2
	srli s1,t1,1               # / by 2
1:
    bltz s1,100f
	mv a1,s1
	addi a2,s0,-1
	call siftDown
	addi s1,s1,-1
	j 1b
	
100:
    lw      ra, 0(sp)
    lw      s0, 4(sp)
	lw      s1, 8(sp)
    addi    sp, sp, 12
    ret	
	
/******************************************************************/
/*          put the heap back in max-heap order                         */
/******************************************************************/
/* a0 contains array address  */
/* a1 contains the first index  */
/* a2 contains the last index  */
siftDown:                      # INFO: siftDown
    addi    sp, sp, -12        # reserve stack
    sw      ra, 0(sp)          # save registers	
	sw      s0, 4(sp)
	sw      s1, 8(sp)
	mv s1,a2                   # init
1:
    slli s0,a1,1
	addi s0,s0,1
    bgt s0,s1,100f
	addi t1,s0,1
	bgt t1,s1,2f
	sh2add t2,s0,a0
	lw t3,(t2)
	sh2add t2,t1,a0
	lw t4,(t2)
	bge t3,t4,2f
	mv s0,t1
2:
	sh2add t2,s0,a0            # compare elements on the table
	lw t3,(t2)
	sh2add t2,a1,a0            # root
	lw t4,(t2)
	bge t4,t3,100f
	mv a2,s0
	call swapElement
	mv a1,s0                   # root = child
	j 1b

100:
    lw      ra, 0(sp)
    lw      s0, 4(sp)
	lw      s1, 8(sp)
    addi    sp, sp, 12
    ret	
/******************************************************************/
/*          swap values in array                          */
/******************************************************************/
/* a0 contains array address  */
/* a1 first indice  */
/* a2 second indice  */
swapElement:                      # INFO: swapElement
    addi    sp, sp, -4         # reserve stack
    sw      ra, 0(sp)          # save registers	
	sh2add t0,a1,a0
	lw t1,(t0)
	sh2add t2,a2,a0
	lw t3,(t2)                 # swap values
	sw t3,(t0)
	sw t1,(t2)
100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret		
/************************************/
/*     file include  Fonctions   */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../includeFunctions.s"
