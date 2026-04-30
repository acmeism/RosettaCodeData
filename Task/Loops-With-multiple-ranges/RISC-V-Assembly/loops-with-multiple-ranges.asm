# riscv assembly raspberry pico2 rp2350
# program loopmulti.s
# connexion putty com3
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
/* for this file see risc-v task include a file */
.include "../../../constantesRiscv.inc"
/****************************************************/
/* MACROS                   */
/****************************************************/
#.include "../ficmacrosriscv.inc"             # only for debugging
/*******************************************/
/* INITIALED DATAS                    */
/*******************************************/
.data
szMessStart:         .asciz "Program riscv start.\r\n"
szMessEndOk:         .asciz "Program riscv end OK.\r\n"
szCariageReturn:     .asciz "\r\n"
szMessResult:        .asciz "Result = "       # message result


.align 2
/*******************************************/
/*  UNINITIALED DATA                    */
/*******************************************/
.bss
sConvArea:         .skip 24

.align 2
iSum:              .skip 4
iProd:             .skip 4


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
	
	la s0,iProd
	li t0,1
	sw t0,(s0)                 # init produit
	la s1,iSum
	li t0,0
	sw t0,(s1)                 # init sum
	
	li s2,5                   # x
    li s3,-5                  # y
    li s4,-2                  # z
    li s5,1                   # un
    li s6,3                   # trois
    li s7,7                   # sept
	li a0,3
    li a1,3
    call computePow           # compute 3 pow 3
    mv s8,a0                  # save result
	neg s9,s6                 # s9 = - three
1:
    mv a0,s9
	call computeSumProd
	add s9,s9,s6
	ble s9,s8,1b
	
	neg s9,s7
2:
    mv a0,s9
	call computeSumProd
	add s9,s9,s2              # add five
	ble s9,s7,2b	
	
	li s9,550
	sub s8,s9,s3              # - y
	li s9,555
3:
    mv a0,s9
	call computeSumProd
	addi s9,s9,1
	ble s9,s8,3b	
	
	li s9,22
	li s8,-28
4:
    mv a0,s9
	call computeSumProd
	sub s9,s9,s6              # decrement by 3
	bge s9,s8,4b	

	li s9,1927
	li s8,1939
5:
    mv a0,s9
	call computeSumProd
	addi s9,s9,1              # increment by 1
	ble s9,s8,5b	

    mv s9,s2                  #  x
	neg s8,s4                 #  - 2
6:
    mv a0,s9
	call computeSumProd
	sub s9,s9,s8              #
	bge s9,s3,6b
	
	mv a0,s2
    li a1,11
    call computePow            # compute 3 pow 3

    add s8,a0,s5               # add 1
	mv s9,a0
7:
    mv a0,s9
	call computeSumProd
	addi s9,s9,1               # increment by 1
	ble s9,s8,7b	
	
	lw a0,(s1)
    la a1,sConvArea            # conversion area
    call conversion10S         # conversion décimale

    la a0,szMessResult
    call writeString           # display message
	la a0,sConvArea
	call writeString
	la a0,szCariageReturn
	call writeString
	
	lw a0,(s0)
    la a1,sConvArea            # conversion area
    call conversion10S         # conversion décimale

    la a0,szMessResult
    call writeString           # display message
	la a0,sConvArea
	call writeString
	la a0,szCariageReturn
	call writeString

 	
    la a0,szMessEndOk          # message address
    call writeString           # display message
    call getchar
100:                           # final loop
    j 100b
/**************************************************/
/*     compute pow                    */
/**************************************************/
/* a0 value   */
/* a1 pow     */
computePow:                # INFO: computePow
    addi    sp, sp, -4
    sw      ra, 0(sp)
    mv t0,a0
    li a0,1
1:
    blez t0,100f
    mul a0,a1,a0
	addi t0,t0,-1
    j 1b	
100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret
/**************************************************/
/*     compute the sum and prod               */
/**************************************************/
/* a0 value   */
computeSumProd:                # INFO: computeSumProd
    addi    sp, sp, -4
    sw      ra, 0(sp)
	srai t0,a0,31
    xor t2,a0,t0
    sub t2,t2,t0               # compute absolue value
	la t3,iSum                 # load sum
	lw t1,(t3)
	add t1,t1,t2
	sw t1,(t3)
	beqz a0,100f               # if j=0
	la t3,iProd                # load product
	lw t1,(t3)
	srai t2,t1,31              # compute absolute value of prod
	xor t4,t1,t2
	sub t2,t4,t2
	li t5,1<<27                # compare 2 puissance 27
	bgt t2,t5,100f
	mul t1,a0,t1
	sw t1,(t3)                 # store prod
100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret

/************************************/
/*     file include  Fonctions      */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../../includeFunctions.s"
