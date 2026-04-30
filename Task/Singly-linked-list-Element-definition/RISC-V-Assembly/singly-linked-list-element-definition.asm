# riscv assembly raspberry pico2 rp2350
# program linkedlist.s
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
szMessNum:           .asciz "Prime : "

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
	sw x0,llist_value(a0)
	sw x0,llist_next(a0)

    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret


/************************************/
/*     file include  Fonctions      */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../../includeFunctions.s"
