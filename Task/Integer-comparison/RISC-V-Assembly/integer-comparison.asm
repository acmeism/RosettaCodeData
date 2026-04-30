# riscv assembly raspberry pico2 rp2350
# program compinteger.s
# connexion putty com3
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
/* for this file see risc-v task include a file */
.include "../../constantesRiscv.inc"

.equ BUFFERSIZE,  80
/*******************************************/
/* INITIALED DATAS                    */
/*******************************************/
.data
szMessStart:         .asciz "Program riscv start.\r\n"
szMessEnd:           .asciz "\nProgram end OK.\r\n"
szCariageReturn:     .asciz "\r\n"
szMessNumber1:       .asciz "Enter an integer  : "
szMessNumber2:       .asciz "Enter other integer  : "
szMessErreurBuf:     .asciz "Buffer too small !!"
szMessErrDep:        .asciz "Number too large for 32 bits\r\n"	
szMessEqual:         .asciz "number 1 equal number 2."
szMessLower:         .asciz "number 1 smaller number 2."
szMessGreater:       .asciz "number 1  greater number 2."
.align 2


/*******************************************/
/*  UNINITIALED DATA                    */
/*******************************************/
.bss
.align 2
sConvArea:       .skip 24
sBuffer:         .skip BUFFERSIZE
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
2:
	la a0,szMessNumber1
	call writeString           # display message
	la a0,sBuffer
	li a1,BUFFERSIZE
	call readString            # read keyboard string
	la a0,sBuffer
	call conversionAtoD        # conversion to decimal
	mv s0,a0
    call displayresult
	
	la a0,szMessNumber2        # number 2
	call writeString
	la a0,sBuffer
	li a1,BUFFERSIZE
	call readString            # read keyboard string
	la a0,sBuffer
	call conversionAtoD        # conversion to decimal
	mv s1,a0
    call displayresult
	blt s0,s1,4f               # compare number 1 number 2
	bgt s0,s1,3f
	la a0,szMessEqual
	call writeString
	j 20f
3:
	la a0,szMessGreater
	call writeString
	j 20f
4:	
	la a0,szMessLower
	call writeString
20:
	la a0,szCariageReturn
	call writeString
    j 2b                      # loop other compare number
	
	la a0,szMessEnd
	call writeString
    call getchar
100:                           # final loop
    j 100b
/***************************************************/
/*      number display               */
/***************************************************/
# a0 contains number
# a0 return length
displayresult:
    addi    sp, sp, -4         # reserve stack
    sw      ra, 0(sp)          # save  registers
	la a1,sConvArea
	call conversion10S          # call decimal conversion
	la a0,sConvArea            # display result message
	call writeString
	la a0,szCariageReturn
    call writeString
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret

/**************************************************/
/*     read keyboard string               */
/**************************************************/
/* a0 buffer address   */
/* a1 buffer size */
readString:                # INFO: readString
    addi    sp, sp, -16
    sw      ra, 0(sp)
    sw      s0, 4(sp)
    sw      s1, 8(sp)
    sw      s2, 12(sp)
    mv s0,a0               # buffer address
    li s1,0
    mv s2,a1
1:
    li a0,100
    call getchar           # read a character
    beqz a0,2f             # end ?
    li a1,0xD
    beq a0,a1,2f           # return char ?
    add t1,s0,s1
    sb a0,(t1)             # store char in buffer
    addi s1,s1,1           # next char
    bge s1,s2,99f
    call putchar           # display char
    j 1b                   # and loop

2:
    add s1,s0,s1
    sb x0,(s1)             # zero final

    li a0,0xA
    call putchar
    li a0,0xD
    call putchar
    mv a0,s1               # return counter character
    j 100f
99:                        # error
    la a0,szMessErreurBuf
    call writeString
    li a0,-1
100:
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    lw      s1, 8(sp)
    lw      s2, 12(sp)
    addi    sp, sp, 16
    ret
/******************************************************************/
/*     String conversion numeric to register                      */
/******************************************************************/
.equ NUMMAXI,    1073741824
/* a0 string address   */
/* a0 return value   */
conversionAtoD:         # INFO: conversionAtoD
    addi    sp, sp, -4  # save registres
    sw      ra, 0(sp)
    li t2,10            # factor
    li t3,0             # counter
    mv t4,a0            # string address
    li t1,0             # default  positive sign
    li a0,0             # init to 0

1:                      # loop removing leading spaces
    add t0,t4,t3
    lbu t5,(t0)         # load a byte
    beqz t5,100f        # string end -> end
    li t0,0x0A          #
    beq t5,t0,100f      # string end -> end
    li t0,' '           #
    bne t5,t0,2f        # no space ?
    addi t3,t3,1        # yes --> loop next position
    j 1b

2:
    li t0,'-'           # first byte is - ?
    bne t5,t0,21f
    li t1,1             # negative sign
    j 4f                # next position
21:
    li t0,'+'           # first byte is + ?
    beq t5,t0,4f        # yes -> next position
3:                      # debut de boucle de traitement des chiffres
    li t0,'0'
    blt t5,t0,4f        # byte is not numeric
    li t0,'9'
    bgt t5,t0,4f        # byte is not numeric
    addi t5,t5,-48
    li t0,NUMMAXI
    bgt a0,t0,99f       # number maxi ?

    mul a0,t2,a0        # multiply by factor 10
    add a0,a0,t5        # and add new byte

4:
    addi t3,t3,1        # next position
    add t0,t4,t3
    lbu t5,(t0)         # load byte
    beq t5,x0,5f        # string end -> end
    li t0,0x0A
    beq t5,t0,5f        # string end -> end
    j 3b                # or loop
5:
    beqz t1,100f        # positive sign ?
    neg a0,a0           # no
    j 100f
99:                     # overflow error
    la a0,szMessErrDep
    call writeString
    li a0,0             # on error  return zero
100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret

/************************************/
/*     file include  Fonctions   */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../includeFunctions.s"
