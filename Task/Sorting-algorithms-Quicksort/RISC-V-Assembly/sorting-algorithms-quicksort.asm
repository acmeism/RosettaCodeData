# riscv assembly raspberry pico2 rp2350
# program quicksort.s
# connexion putty com3
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
/* for this file see risc-v task include a file */
.include "../../../constantesRiscv.inc"

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
	call quickSort            # sort
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
/*                        */
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
/*         quick sort                                         */
/******************************************************************/
/* a0 contains array address */
/* a1 contains the first element    */
/* a2 contains the last element  */
quickSort:
    addi    sp, sp, -16        # reserve stack
    sw      ra, 0(sp)          # save registers
	sw      s0, 4(sp)
	sw      s1, 8(sp)
	sw      s2, 12(sp)
	bge a1,a2,100f             # first > last ? -> end
	mv s0,a0                   # save address area
	mv s1,a1                   # save first indice
	mv s2,a2                   # save last indice
    call partition             # partitioning
	addi  a2,a0,-1             # index partition - 1
	mv a1,s1                   # move first index
	mv s1,a0                   # save partition index
	mv a0,s0                   # array address
	call quickSort             # sort lower part
	addi a1,s1,1               # partition index + 1
	mv a2,s2                   # last index
	mv a0,s0
	call quickSort	           # sort higter part
	
100:
    lw      ra, 0(sp)
    lw      s0, 4(sp)
	lw      s1, 8(sp)
	lw      s2, 12(sp)
    addi    sp, sp, 16
    ret
/******************************************************************/
/*         shell sort                                         */
/******************************************************************/
/* a0 contains the address of table */
/* a1 contains index of first item  */
/* a2 contains index of last item   */
partition:                     # INFO: partition
    addi    sp, sp, -4         # reserve stack
    sw      ra, 0(sp)          # save registers	
	mv t0,a1                   # init with first index
	mv t1,a1                   # init with first index
	sh2add t2,a2,a0	
	lw t3,(t2)                 # load value last index
1:                             # begin loop
    sh2add t2,t1,a0	
	lw t4,(t2)                 # load value
	bge t4,t3,2f               # compare value 2
	sh2add t2,t0,a0            # if value2 < value 1 -> swap values
	lw t5,(t2)
	sh2add t2,t0,a0
	sw t4,(t2)
	sh2add t2,t1,a0
	sw t5,(t2)
	addi t0,t0,1               # increment index
2:
 	addi t1,t1,1               # increment index 2
    blt t1,a2,1b               # < maxi -> loop
	sh2add t2,t0,a0            # else swap value
	lw t5,(t2)
	sh2add t2,t0,a0
	sw t3,(t2)
	sh2add t2,a2,a0
  	sw t5,(t2)
	mv a0,t0                   # return index partition	
	
100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret	
/************************************/
/*     file include  Fonctions   */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../../includeFunctions.s"
