# riscv assembly raspberry pico2 rp2350
# program dbllinkedlist.s
# connexion putty com3
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
/* for this file see risc-v task include a file */
.include "../../../constantesRiscv.inc"
.equ HEAPSIZE,         50000
/****************************************************/
/* MACROS                   */
/****************************************************/
#.include "../ficmacrosriscv.inc"             # only for debugging

/*******************************************/
/* STRUCTURE                    */
/*******************************************/
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
szMessStart:         .asciz "Program riscv start.\r\n"
szMessEndOk:         .asciz "Program riscv end OK.\r\n"
szCariageReturn:     .asciz "\r\n"

szMessInitListe:         .asciz "List initialized.\n"
szMessErreur:            .asciz "Error detected.\n"
szMessResult:            .asciz "Element No :"
szMessResultValue:       .asciz " value :  "
szMessInverse:           .asciz "\nList inverse : \n"
.align 2
ptHeapReserve:        .int heapReserve
/*******************************************/
/*  UNINITIALED DATA                    */
/*******************************************/
.bss
sConvArea:           .skip 24
.align 2
dlList1:              .skip dllist_end    # list memory place
heapReserve:          .skip HEAPSIZE

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
	
	la a0,dlList1
    call newDList              # create new list
    la a0,szMessInitListe
    call writeString
	

	
	la a0,dlList1               # list address
	li a1,5000                    # value to insert
	call insertTail             # insertion at head
	bgez a0,2f                 # error ?
	la a0,szMessErreur
	call writeString
	j 10f
2:
	la a0,dlList1               # list address
	li a1,42                    # value to insert
	call insertHead             # insertion at head
	bgez a0,3f                 # error ?
	la a0,szMessErreur
	call writeString
	j 10f
	
3:	
	la a0,dlList1               # list address
	li a1,42                    # search value
	li a2,1234567               # value to insert
	call insertAfter            # insertion after node contains search value
	bgez a0,4f                  # error ?
	la a0,szMessErreur
	call writeString
	j 10f
4:

    la s0,dlList1              # list address
	lw s0,dllist_head(s0)
	beqz s0,10f               # empty list
	li s1,1                   # n0 element
5:	
	lw s2,NDlist_value(s0)      # load pointer
	#beqz s2,10f               # end list ?
	la a0,szMessResult
	call writeString
	mv a0,s1                  # conversion and display N° element
	la a1,sConvArea
	call conversion10
	la a0,sConvArea
	call writeString
	
    la a0,szMessResultValue	
	call writeString	
	mv a0,s2                  # conversion and display value element
	la a1,sConvArea
	call conversion10
	la a0,sConvArea
	call writeString
	la a0,szCariageReturn
	call writeString
    addi s1,s1,1
	lw s0,NDlist_next(s0)      # load next pointer
	bnez s0,5b                 # not null pointer -> loop
	
	la a0,szMessInverse
	call writeString
    la s0,dlList1              # list address
	lw s0,dllist_tail(s0)
	beqz s0,10f                # empty list
	li s1,1                    # n0 element
6:	
	lw s2,NDlist_value(s0)     # load pointer
	#beqz s2,10f               # end list ?
	la a0,szMessResult
	call writeString
	mv a0,s1                   # conversion and display N° element
	la a1,sConvArea
	call conversion10
	la a0,sConvArea
	call writeString
	
    la a0,szMessResultValue	
	call writeString	
	mv a0,s2                   # conversion and display value element
	la a1,sConvArea
	call conversion10
	la a0,sConvArea
	call writeString
	la a0,szCariageReturn
	call writeString
    addi s1,s1,1
	lw s0,NDlist_prev(s0)      # load next pointer
	bnez s0,6b                 # not null pointer -> loop
	
10:		
    la a0,szMessEndOk          # message address
    call writeString           # display message
    call getchar
100:                           # final loop
    j 100b

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
	mv s0,a0 	                    # save address
	mv a0,a1                        # value
	call createNode                 # create new node
	bltz a0,100f                    # error ?
	
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
/* insertion value in Tail       */
/**********************************************/
/* a0 double linked list address */
/* a1 contains the value of element  */
/* a0 returns address of element or - 1 if error */
insertTail:                      # INFO: insertTail
    addi    sp, sp, -8
    sw      ra, 0(sp)
	sw      s0, 4(sp)
	mv s0,a0 	                    # save address
	mv a0,a1                        # value
	call createNode                 # create new node
	bltz a0,100f                    # error ?
	
    lw t0,dllist_tail(s0)           # load address last node
	sw t0,NDlist_prev(a0)           # store in previous pointer on new node
	sw x0,NDlist_next(a0)           # store null un next pointer
	sw a0,dllist_tail(s0)           # store address new node on list tail
	beqz t0,1f                      # address last node is null ?
	sw a0,NDlist_next(t0)           # no store address new node in next pointer
	j 2f
1:
	sw a0,dllist_head(s0)           # else store in head list
2:

100:
    lw      ra, 0(sp)
	lw      s0, 4(sp)
    addi    sp, sp, 8
    ret
/**********************************************/
/* insertion value in after search value       */
/**********************************************/
/* a0 double linked list address */
/* a1 contains the search value after that insert  */
/* a2 contains the value of element  */
/* a0 returns address of element or - 1 if error */
insertAfter:                       # INFO: insertAfter
    addi    sp, sp, -12
    sw      ra, 0(sp)
	sw      s0, 4(sp)
	sw      s1, 8(sp)
	mv s0,a0 	                    # save address
	call searchValue
	bltz a0,100f                    # error ?
	mv s1,a0                        # save address find node
	mv a0,a2                        # value
	call createNode                 # create new node
	bltz a0,100f                    # error ?
	
    lw t0,NDlist_next(s1)           # load pointer next of find node
	sw a0,NDlist_next(s1)           # store new node in pointer next
	sw s1,NDlist_prev(a0)           # store address find node in previous pointer on new node
    sw t0,NDlist_next(a0)           # store pointer next of find node on pointer next on new node
	
	beqz t0,1f                      # address next node null ?
	sw a0,NDlist_prev(t0)           # no store address new node in previous pointer
	j 2f
1:
	sw a0,dllist_tail(s0)           # else store in tail list
2:

100:
    lw      ra, 0(sp)
	lw      s0, 4(sp)
	lw      s1, 8(sp)
    addi    sp, sp, 12
    ret
	
/**********************************************/
/* search value in double linked list       */
/**********************************************/
/* a0 contains the address of the list structure */
/* a1 contains the value to search  */
/* a0 return address of node or -1 if not found */
searchValue:                      # INFO: searchValue
    addi    sp, sp, -4
	sw      ra, 0(sp)
	lw t0,dllist_head(a0)         # load first node
1:
    bnez t0,2f                    # equal zero ?
	li a0,-1                      # yes -> not found -> end
	j 100f
2:
    lw t1,NDlist_value(t0)        # load node value
    bne t1,a1,3f                  # equal search value ?
    mv a0,t0                      # yes -> end
    j 100f	
3:
	lw t0,NDlist_next(t0)         # load address nex node
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
/************************************/
/*     file include  Fonctions      */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../../includeFunctions.s"
