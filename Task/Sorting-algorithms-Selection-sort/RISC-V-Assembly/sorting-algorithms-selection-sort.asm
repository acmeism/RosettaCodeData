# riscv assembly raspberry pico2 rp2350
# program selectionsort.s
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
tabNumber:        .int 5,7,8,3,2,9,11,1,4,10,6
#tabNumber:        .int 11,10,9,8,7,6,5,4,3,2,1
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
	call selectionSort             # sort
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
/*         selection sort                                         */
/******************************************************************/
/* a0 contains array address */
/* a1 contains the first element    */
/* a2 contains the last element  */
selectionSort:
    addi    sp, sp, -12        # reserve stack
    sw      ra, 0(sp)          # save registers
	sw      s0, 4(sp)
	sw      s1, 8(sp)
	mv t1,a1
1:                            # start loop 1
    mv t0,t1	              # start index
	addi t4,t0,1
2:                            # start loop 2
    sh2add t6,t0,a0
    lw s0,(t6)	
    sh2add s1,t4,a0
    lw t2,(s1)
    bge t2,s0,3f
	mv t0,t4
3:	
    addi t4,t4,1
    ble t4,a2,2b
	beq t0,t1,4f
    sh2add t6,t0,a0
    lw s0,(t6)	
    sh2add s1,t1,a0
    lw t2,(s1)	
    sw t2,(t6)                # swap value
    sw s0,(s1)
4:
    addi t1,t1,1
	ble t1,a2,1b              # end ? no -> loop 1
		
100:
    lw      ra, 0(sp)
    lw      s0, 4(sp)
	lw      s1, 8(sp)
    addi    sp, sp, 12
    ret

/************************************/
/*     file include  Fonctions   */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../includeFunctions.s"
