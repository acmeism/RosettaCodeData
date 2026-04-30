# riscv assembly raspberry pico2 rp2350
# program guessnumber.s
# connexion putty com3
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
/* for this file see risc-v task include a file */
.include "../../../constantesRiscv.inc"
.equ BUFFERSIZE,        80
/*******************************************/
/* INITIALED DATAS                    */
/*******************************************/
.data
szMessStart:         .asciz "Program riscv start.\r\n"
szMessEndOk:         .asciz "Program riscv end OK.\r\n"
szCariageReturn:     .asciz "\r\n"

szMessNum:           .asciz "I'm thinking of a number between 1 and 10. \n Try to guess it:\n"

szMessError:         .asciz "That's not my number. Try another guess:\n"
szMessSucces:        .asciz "Correct.\n"
szMessErreurBuf:     .asciz "Buffer size error."
szMessErrDep:        .asciz "Number too large error"
.align 2
/*******************************************/
/*  UNINITIALED DATA                    */
/*******************************************/
.bss
sConvArea:   .skip 24
sBuffer:     .skip BUFFERSIZE
.align 2

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
	
	li a0,10
	call getRandom
	bnez a0,2f
	addi a0,a0,1
2:
	mv s0,a0                   # save random number

    la a0,szMessStart          # message address
    call writeString           # display message
	
	la a0,szMessNum
    call writeString
3:	                           # loop begin
    la a0,sBuffer
	li a1,BUFFERSIZE
	call readString            # entry number
	la a0,sBuffer
	call conversionAtoD        # conversion string to number
	beq a0,s0,4f               # compare numbers
	la a0,szMessError          # no correct
	call writeString
	j 3b                       # and loop
4:	
	la a0,szMessSucces         # it is ok
	call writeString
	
    la a0,szMessEndOk          # message address
    call writeString           # display message
    call getchar
100:                           # final loop
    j 100b
/**************************************************/
/*     saisie des commandes               */
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
    mv s2,a1               # buffer size
1:
    li a0,100
    call getchar           # character read
    beq a0,x0,2f           # zero ?
    li a1,0xD              # return carriage
    beq a0,a1,2f
    add t1,s0,s1           # compute address buffer
    sb a0,(t1)             # store character in buffer
    addi s1,s1,1           # increment indice
    bge s1,s2,99f
    call putchar           # write charactere for display in host
    j 1b                   # and loop

2:
    add s1,s0,s1
    sb x0,(s1)             # zero final

    li a0,0xA
    call putchar
    li a0,0xD
    call putchar
	mv a0,s0
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
/*     Convert string to number in registre             */
/******************************************************************/
#.equ NUMMAXI,    1073741824
.equ NUMMAXI,    2^30
/* a0 contains address string ended by 0 ou 0A */
conversionAtoD:         # INFO: conversionAtoD
    addi    sp, sp, -8  # save registres
    sw      ra, 0(sp)
    li t1,0
    li t2,10            # factor
    li t3,0             # counter
    mv t4,a0            # address save
    li t6,0             # signe positive
    li a0,0             # init number

1:                      # loop to suppress begin space
    add t0,t4,t3
    lbu t5,(t0)         # load charracter
    beq t5,x0,100f      # zero final -> end routine
    li t0,0x0A
    beq t5,t0,100f      #  0Ah -> end routine
    li t0,' '           #  begin space ?
    bne t5,t0,2f        #  no -> continue
    addi t3,t3,1        #  oui on boucle en avançant d'un octet
    j 1b

2:
    li t0,'-'           # first character is  -
    bne t5,t0,3f
    li t6,1
    j 4f                # next location

3:                      # begin loop
    li t0,'0'
    blt t5,t0,4f        # character is not a number
    li t0,'9'
    bgt t5,t0,4f        # character is not a number
    addi t5,t5,-48      # conversion ascii to decimal
    li t0,NUMMAXI       # maxi ?
    bgt a0,t0,99f
    mul a0,t2,a0        # factor multiplication
    add a0,a0,t5        # add to register

4:
    addi t3,t3,1        # next location
    add t0,t4,t3
    lbu t5,(t0)         # load byte
    beq t5,x0,5f        # zero final -> end routine
    li t0,0x0A
    beq t5,t0,5f        # zero final -> end routine
    j 3b                # loop

5:
    beq t6,x0,100f      # positive sign ?
    sub a0,x0,a0        # inverse if negative
    j 100f

99:                     # error number too large
    la a0,szMessErrDep
    call writeString
    li a0,0             # if error return zero

100:
    lw      ra, 0(sp)
    addi    sp, sp, 8
    ret  	
/************************************/
/*       random generator            */
/***********************************/
.equ  TRNG_BASE,          0x400f0000
.equ  RND_SOURCE_ENABLE,  0x12c
.equ  RNG_ISR,            0x104
.equ TRNG_VALID,          0x110
.equ EHR_DATA0,           0x114
.equ EHR_DATA1,           0x118
/* a0 contains limit  */
getRandom:                       # INFO: getRandom
    addi    sp, sp, -8           # save registres
    sw      ra, 0(sp)
    la t0,TRNG_BASE              # base address
    li t1,1
    sw t1,RND_SOURCE_ENABLE(t0)  # enable random

1:                               # loop attente ok
    lw t1,TRNG_VALID(t0)
    beqz t1,1b

    lw t2,EHR_DATA0(t0)          # begin random 32 bits
	remu a0, t2, a0              # remainder

    la t0,TRNG_BASE
    sw x0,RND_SOURCE_ENABLE(t0)  # Raz bit enable
100:
    lw      ra, 0(sp)
    addi    sp, sp, 8
    ret
/************************************/
/*     file include  Fonctions   */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../../includeFunctions.s"
