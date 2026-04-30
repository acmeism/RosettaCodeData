# riscv assembly raspberry pico2 rp2350
# program mergesort.s
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
	addi a2,s2,-1              # last item
	call mergeSort             # sort
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
/*         merge sort                                         */
/******************************************************************/
/* a0 contains array address */
/* a1 contains the first element    */
/* a2 contains the last element  */
mergeSort:
    addi    sp, sp, -20        # reserve stack
    sw      ra, 0(sp)          # save registers
	sw      s0, 4(sp)
	sw      s1, 8(sp)
	sw      s2, 12(sp)
	sw      s3, 16(sp)
	li t0,1
	blt a2,t0,100f             # end < 1 -> end
	ble a2,a1,100f             # first > last ? -> end
	srli t0,a2,1               # number of element of each subset
	bge t0,a1,1f
	mv t0,a1
1:   	
	mv s0,a0                   # save address area	
	mv s1,a1                   # save first indice
	mv s2,a2                   # save last indice
	mv s3,t0                   # save last indice
	mv a2,t0                   # sort set 1
    call mergeSort             #
	addi a1,s3,1                # index set 2
	mv a2,s2                   # index end
	mv a0,s0                   # array address
	call mergeSort             # sort lower part
	mv a1,s1                   # fist index set 1
	mv a2,s3                   # last index set 1
	addi a2,a2,1               # start index set 2
	mv a3,s2                   # last index set 2
	mv a0,s0                   # array address
	call merge	               # merge two sets
	
100:
    lw      ra, 0(sp)
    lw      s0, 4(sp)
	lw      s1, 8(sp)
	lw      s2, 12(sp)
	lw      s3, 16(sp)
    addi    sp, sp, 20
    ret
/******************************************************************/
/*         merge                                          */
/******************************************************************/
/* a0 contains the address of table */
/* a1 contains first start index  */
/* a2 contains second start index   */
/* a3 contains the last index   */
merge:                     # INFO: merge
    addi    sp, sp, -4         # reserve stack
    sw      ra, 0(sp)          # save registers	
	mv t0,a2                   # init with second index
1:	
	sh2add t2,a1,a0	
	lw t3,(t2)                 # load value first index
    sh2add t4,t0,a0	
	lw t5,(t4)                 # load value second index
	ble t3,t5,4f               # <=  -> location first section OK
	
	sw t5,(t2)                 # store value second section in first section
	addi t1,t0,1
	ble t1,a3,2f               # end section 2 ?
	sw t3,(t4)                 # store element section 1 in section 2
	j 4f
2:                             # loop insert element part 1 into part 2
	addi t6,t1,-1
	sh2add t4,t1,a0	
	lw t5,(t4)                 # load value second set
	bge t3,t5,3f               # compare value set 1 value set 2
	sh2add t4,t6,a0	           # <
	sw t3,(t4)                 # store value 1
	j 4f                       # and loop
3:                             # value 1 > value 2
	sh2add t4,t6,a0	
	sw t5,(t4)                 # store value 2
	addi  t1,t1,1              # increment indice
	ble t1,a3,2b               # end set 2 ?  no - > loop
	addi  t1,t1,-1             #
	sh2add t4,t1,a0	
	sw t3,(t4)                 # store value set 1 in last post
4:	
    addi a1,a1,1
	ble a1,a2,1b               # end first section ?
100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret	
/************************************/
/*     file include  Fonctions   */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../includeFunctions.s"
