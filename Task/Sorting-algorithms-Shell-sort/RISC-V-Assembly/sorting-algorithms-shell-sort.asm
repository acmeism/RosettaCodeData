# riscv assembly raspberry pico2 rp2350
# program shellsort.s
# connexion putty com3
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
/* for this file see risc-v task include a file */
.include "../../../constantesRiscv.inc"

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
	addi a2,s2,-1              # last item
	call shellSort             # sort
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
/*         shell sort                                         */
/******************************************************************/
/* a0 contains array address */
/* a1 contains the first element    */
/* a2 contains the last element  */
shellSort:
    addi    sp, sp, -4         # reserve stack
    sw      ra, 0(sp)          # save registers
	sub t0,a2,a1               # init gap
	addi t0,t0,1
1:                             # start loop 1
    srli t0,t0,1               # gap = gap / 2
	beqz t0,100f               # if gap = 0 -> end
	mv t3,t0                   # init indice loop 1
	add t3,t3,a1               # add first indice
2:                             # start loop 2
    sh2add t2,t3,a0
	lw  t4,(t2)                # load value A[i]
	mv t5,t3                   #  index j
3:                             # start loop 3
    sub t1,t5,a1               # - first indice
    blt t1,t0,4f               # indice < gap
    sub t6,t5,t0               # index = indice - gap	
    sh2add t2,t6,a0
	lw  t6,(t2)                # load value A[j]
	bge t4,t6,4f               # compare value A[i] and A[j]
	sh2add t2,t5,a0
	sw  t6,(t2)                # store value A[j+1]
	sub t5,t5,t0               # index = indice - gap
	j 3b	                   # and loop 3
4:
	sh2add t2,t5,a0
	sw  t4,(t2)                # store value A[i] in A[j+1]
	addi t3,t3,1               #  increment index i
	ble t3,a2,2b               # end ? no -> loop 2
	j 1b                       # loop 1
100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret
/************************************/
/*     file include  Fonctions   */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../../includeFunctions.s"
