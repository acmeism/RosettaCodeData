# riscv assembly raspberry pico2 rp2350
# program linkedlist2.s
# connexion putty com3
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
/* for this file see risc-v task include a file */
.include "../../../constantesRiscv.inc"
.equ NBELEMENTS,      100                # list size
/****************************************************/
/* MACROS                   */
/****************************************************/
#.include "../ficmacrosriscv.inc"             # only for debugging

/*******************************************/
/* STRUCTURE                    */
/*******************************************/
/* structure linkedlist*/
    .struct  0
llist_next:                             # next element
    .struct  llist_next + 4
llist_value:                            # element value
    .struct  llist_value + 4
llist_fin:
/*******************************************/
/* INITIALED DATAS                    */
/*******************************************/
.data
szMessStart:         .asciz "Program riscv start.\r\n"
szMessEndOk:         .asciz "Program riscv end OK.\r\n"
szCariageReturn:     .asciz "\r\n"
/* datas error display */
szMessErreur:            .asciz "Error detected.\n"
/* datas message display */
szMessResult:            .asciz "Element No :"
szMessResultValue:       .asciz " value :  "

.align 2
/*******************************************/
/*  UNINITIALED DATA                    */
/*******************************************/
.bss
sConvArea:           .skip 24
.align 2
lList1:              .skip llist_fin * NBELEMENTS    # list memory place

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
    beqz a0,1b                 # return code = zero ? yes -> loop
	
    la a0,szMessStart          # message address
    call writeString           # display message
	
	la a0,lList1               # list address
	call initLinkedList
	
	la a0,lList1               # list address
	li a1,5000                    # value to insert
	call insertElement         # insertion
	bgez a0,2f                 # error ?
	la a0,szMessErreur
	call writeString
	j 10f
2:
	la a0,lList1               # list address
	li a1,1234567                   # value to insert
	call insertElement
	bgez a0,3f
	la a0,szMessErreur
	call writeString
	j 10f
3:
	la a0,lList1               # list address
	li a1,88888                   # value to insert
	call insertElement
	bgez a0,4f
	la a0,szMessErreur
	call writeString
	j 10f
4:

    la s0,lList1              # list address
	li s1,1                   # n0 element
5:	
	lw s2,llist_next(s0)      # load pointer
	beqz s2,10f               # end list ?
	la a0,szMessResult
	call writeString
	mv a0,s1                  # conversion and display N° element
	la a1,sConvArea
	call conversion10
	la a0,sConvArea
	call writeString
	
    la a0,szMessResultValue	
	call writeString	
	lw a0,llist_value(s0)     # conversion and display value element
	la a1,sConvArea
	call conversion10
	la a0,sConvArea
	call writeString
	la a0,szCariageReturn
	call writeString
    addi s1,s1,1
    mv s0,s2                  # new pointer
    j 5b	                  # and loop
	
10:		
    la a0,szMessEndOk          # message address
    call writeString           # display message
    call getchar
100:                           # final loop
    j 100b

/**********************************************/
/* initialisation linkedlist      */
/**********************************************/
/* a0 linked list address */
initLinkedList:                      # INFO: initLinkedList
    addi    sp, sp, -4
    sw      ra, 0(sp)
	sw x0,llist_value(a0)            # raz value
	sw x0,llist_next(a0)             # raz pointer

    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret
/**********************************************/
/* insertion element in linked list      */
/**********************************************/
/* a0 linked list address */
/* a1 contains the value of element  */
/* a0 returns address of element or - 1 if error */
insertElement:                      # INFO: insertElement
    addi    sp, sp, -4
    sw      ra, 0(sp)
	li t0,llist_fin * NBELEMENTS
    add t0,t0,a0                    # compute address end list
	mv t1,a0
1:	
    lw t3,llist_next(t1)            # load next pointer
	beqz t3,2f                      # end list ?
	mv t1,t3                        # no -> loop with pointer
	j 1b
2:
	addi t3,t1,llist_fin            # yes -> compute next free address
	blt t3,t0,3f                   #  < list end  -> ok
	li a0,-1
	j 100f
3:	
	sw t3,llist_next(t1)            # store next address in current pointer
	sw a1,llist_value(t1)           # store element value
	sw x0,llist_value(t3)           # init new eleùent
	sw x0,llist_next(t3)
	mv a0,t1
100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret

/************************************/
/*     file include  Fonctions      */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../../includeFunctions.s"
