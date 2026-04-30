# riscv assembly raspberry pico2 rp2350
# program insertionsort.s
# connexion putty com3
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
/* for this file see risc-v task include a file */
.include "../../constantesRiscv.inc"



/*******************************************/
/* INITIALED DATAS                    */
/*******************************************/
.data
szMessStart:        .asciz "Program riscv start.\r\n"
szMessEnd:          .asciz "\nProgram end OK.\r\n"
szCariageReturn:    .asciz "\r\n"

szLibSort:          .asciz "\nAfter sort\n"
szSpace:          .asciz " "

.align 2
tabNumber:        .int 5,7,8,3,2,9,1,4,6
.equ NBTABNUMBER1, . - tabNumber
.equ NBTABNUMBER, NBTABNUMBER1 / 4 # compute items number

/*******************************************/
/*  UNINITIALED DATA                    */
/*******************************************/
.bss
.align 2
sConvArea:       .skip 24

/**********************************************/
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
	mv a2,s2                   # item size
	call insertionSort         # sort
	
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


/******************************************************************/
/*         insertion sort                                         */
/******************************************************************/
/* a0 contains array address */
/* a1 contains the first element    */
/* a2 contains the number of element */
insertionSort:
    addi    sp, sp, -4         # reserve stack
    sw      ra, 0(sp)          # save registers
	addi t1,a1,1               # start index i
1:                             # start loop
    sh2add t2,t1,a0
	lw  t3,(t2)                # load value A[i]
	addi t5,t1,-1              #  index j
2:
    sh2add t2,t5,a0
	lw  t6,(t2)                # load value A[j]
	ble t6,t3,3f               # compare value A[i] and A[j]
	
	addi t5,t5,1               # increment index j
	sh2add t2,t5,a0
	sw  t6,(t2)                # store value A[j+1]

	addi t5,t5,-2              # j = i - 1
	bge t5,a1,2b	           # loop if j >= first item
3:
    addi t5,t5,1
	sh2add t2,t5,a0
	sw  t3,(t2)                # store value A[i] in A[j+1]
	addi t1,t1,1               #  increment index i
	blt t1,a2,1b               # end ?
100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret
/************************************/
/*     file include  Fonctions   */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../includeFunctions.s"
