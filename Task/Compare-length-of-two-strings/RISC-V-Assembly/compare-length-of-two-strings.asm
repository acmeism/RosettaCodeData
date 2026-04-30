# riscv assembly raspberry pico2 rp2350
# program complength.s
# connexion putty com3
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
/* for this file see risc-v task include a file */
.include "../../constantesRiscv.inc"

/************************************/
/* structures                       */
/************************************/
   .struct  0
list_string:                             # string address
    .struct  list_string + 4
list_length:                             # string length
    .struct  list_length + 4
list_end:

/*******************************************/
/* INITIALED DATAS                    */
/*******************************************/
.data
szMessStart:        .asciz "Program riscv start.\r\n"
szMessEnd:          .asciz "\nProgram end OK.\r\n"
szCariageReturn:    .asciz "\r\n"
szMessResult:       .asciz " length : "

szLibSort:          .asciz "\nAfter sort\n"
szString1:          .asciz "abcd"
szString2:          .asciz "123456789"
szString3:          .asciz "abcdef"
szString4:          .asciz "1234567"

.align 2
tabStrings:        .int szString1           # string address array
                   .int 0
                   .int szString2
                   .int 0
                   .int szString3
                   .int 0
                   .int szString4
                   .int 0
.equ NBTABSTRINGS1, . - tabStrings
.equ NBTABSTRINGS, NBTABSTRINGS1 / list_end # compute items number

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
	
	la s0,tabStrings           # string array address
	li s1,0
	li s2,list_end
	li s3,NBTABSTRINGS
2:                             # item loop
    mul s4,s1,s2               # compute item address
    add s4,s4,s0
	lw  a0,list_string(s4)     # load string address
	call stringRoutine         # length string compute
	sw a0,list_length(s4)      # store result in array
	addi s1,s1,1               # increment indice
	blt s1,s3,2b               # no -> loop
	mv a0,s0                   # string array address
	li a1,0                    # first item
	li a2,NBTABSTRINGS         # item size
	call insertionSort         # sort
	
	la a0,szLibSort
	call writeString

	li s1,0
	li s2,list_end

3:                             # item loop
    mul t3,s1,s2               # compute item address
    add t3,t3,s0
	lw a0,list_string(t3)
	call stringRoutine         # use same routine for display result after sort
	add s1,s1,1
	blt s1,s3,3b

	la a0,szMessEnd
	call writeString
    call getchar
100:                           # final loop
    j 100b
/***************************************************/
/*      string exec               */
/***************************************************/
# a0 contains string address
# a0 return length
stringRoutine:
    addi    sp, sp, -8         # reserve stack
    sw      ra, 0(sp)          # save  registers
	sw      s0, 4(sp)
	mv s0,a0                   # save string address
	call writeString
	la a0,szMessResult
    call writeString
	mv a0,s0
	call stringlength          # compute length
	mv s0,a0
	la a1,sConvArea
	call conversion10          # call decimal conversion
	la a0,sConvArea            # display result message
	call writeString
	la a0,szCariageReturn
    call writeString
	mv a0,s0                   # return length

100:
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    addi    sp, sp, 8
    ret
/***************************************************/
/*     compute string length               */
/***************************************************/
# a0 contains string address
stringlength:
    addi    sp, sp, -4         # reserve stack
    sw      ra, 0(sp)          # save  registers              @ save  registers
    li t1,-1                   # init counter
1:                             # loop
    addi t1,t1,1               # increment counter
	add t0,a0,t1               # compute byte address
    lbu t2,(t0)                # load byte string
	bnez t2,1b                 # zero final ?
    mv a0,t1                   #return length
100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret

/******************************************************************/
/*         insertion sort                                         */
/******************************************************************/
/* a0 contains the address of table */
/* a1 contains the first element    */
/* a2 contains the number of element */
insertionSort:
    addi    sp, sp, -4         # reserve stack
    sw      ra, 0(sp)          # save registers
	li t0,list_end
	addi t1,a1,1               # start index i
	
1:                             # start loop
    mul t2,t1,t0
	add t2,t2,a0
	lw  t3,list_length(t2)     # load value A[i]
	lw  t4,list_string(t2)     # load string address A[i]
	addi t5,t1,-1              #  index j

2:
    mul t2,t5,t0
	add a3,t2,a0
	lw  t6,list_length(a3)     # load value A[j]
	bge t6,t3,3f               # compare value A[i] and A[j]
	
	addi t5,t5,1               # increment index j
	mul t2,t5,t0
	add t2,t2,a0
	sw  t6,list_length(t2)     # store value A[j+1]
	lw  t6,list_string(a3)     # load string address A[i]
	sw  t6,list_string(t2)     # store string address
	addi t5,t5,-2              # j = i - 1
	bge t5,a1,2b	           # loop if j >= first item
3:
    addi t5,t5,1
	mul t2,t5,t0
	add t2,t2,a0
	sw  t3,list_length(t2)     # store value A[i] in A[j+1]
    sw  t4,list_string(t2)     # store string address
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
