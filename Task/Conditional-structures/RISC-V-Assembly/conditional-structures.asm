# riscv assembly raspberry pico2 rp2350
# program condstruct.s
# connexion putty com3
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
/* for this file see risc-v task include a file */
.include "../../constantesRiscv.inc"
.equ BUFFERSIZE,          255
/*******************************************/
/* INITIALED DATAS                    */
/*******************************************/
.data
szMessStart:         .asciz "Program riscv start.\r\n"
szMessEndOk:         .asciz "Program riscv end OK.\r\n"
szCariageReturn:     .asciz "\r\n"

szMessTest1: .asciz "The test 1 is equal.\n"
szMessTest1N: .asciz "The test 1 is not equal.\n"
szMessTest2: .asciz "The test 2 is equal.\n"
szMessTest2N: .asciz "The test 2 is not equal.\n"
szMessTest3: .asciz "The test 3 is equal.\n"
szMessTest3N: .asciz "The test 3 is not equal.\n"
szMessTest4: .asciz "The test 4 is equal.\n"
szMessTest4N: .asciz "The test 4 is not equal.\n"

szMessTest5: .asciz "The test 5 is <.\n"
szMessTest5N: .asciz "The test 5 is not <.\n"
szMessTest6: .asciz "The test 6 is <.\n"
szMessTest6N: .asciz "The test 6 is not <.\n"
szMessTest7: .asciz "The test 7 is >=.\n"
szMessTest7N: .asciz "The test 7 is not >=.\n"

szMessTest8:  .asciz "Result test 8 (slt) : "
szMessTest9:  .asciz "Result test 9 (snez) : "


.align 2
/*******************************************/
/*  UNINITIALED DATA                    */
/*******************************************/
.bss
sConvArea:   .skip 24
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

    la a0,szMessStart          # message address
    call writeString           # display message
	
	# TEST 1 : test equal zero
    #li  t0,0      # comments
    li  t0,1       # or uncomments
	beqz t0,1f
    la a0,szMessTest1N
	j 2f
1:
    la a0,szMessTest1
2:	
    call writeString
	
	# TEST 2 :  test  not equal zero
    #li  t0,0      # comments
    li  t0,1       # or uncomments
	bnez t0,1f
    la a0,szMessTest2
	j 2f
1:
    la a0,szMessTest2N
2:	
    call writeString
	
	# TEST 3 :  test  equal 5
    #li  t0,1      # comments
    li t0,5       # or uncomments
	li t1,5
	beq t0,t1,1f
    la a0,szMessTest3N
	j 2f
1:
    la a0,szMessTest3
2:	
    call writeString
	
	# TEST 4 :  test  not equal 5
    #li  t0,5     # comments
    li t0,6       # or uncomments
	li t1,5
	bne t0,t1,1f
    la a0,szMessTest4
	j 2f
1:
    la a0,szMessTest4N
2:	
    call writeString
	
	# TEST 5 :  test  < 5  SIGNED
    li  t0,-6              # comments
    #li t0,4                # or uncomments
	li t1,5
	blt t0,t1,1f
    la a0,szMessTest5N
	j 2f
1:
    la a0,szMessTest5
2:	
    call writeString
	
    # TEST 6 :  test  < 5  UNSIGNED
    li  t0,-6              # comments
    #li t0,4                # or uncomments
	li t1,5
	bltu t0,t1,1f
    la a0,szMessTest6N
	j 2f
1:
    la a0,szMessTest6
2:	
    call writeString
	
    # TEST 7 :  test  >= 5  SIGNED
    li  t0,-6              # comments
    #li t0,4                # or uncomments
	li t1,5
	bge t0,t1,1f
    la a0,szMessTest7N
	j 2f
1:
    la a0,szMessTest7
2:	
    call writeString
	
	# TEST8   value 1 if 4 < 5 else value 0
    la a0,szMessTest8
    call writeString
    li t0,4     	# comments or uncomments
	#li t0,6        # comments or uncomments
	li t1,5
	slt a0,t0,t1
	la a1,sConvArea
	call conversion10
	la a0,sConvArea
	call writeString
	la a0,szCariageReturn
	call writeString

	# TEST9   value 1 if t0 <>0 else value 0
    la a0,szMessTest9
    call writeString
    li t0,4     	# comments or uncomments
	#li t0,0        # comments or uncomments
	snez a0,t0
	la a1,sConvArea
	call conversion10
	la a0,sConvArea
	call writeString
	la a0,szCariageReturn
	call writeString


    la a0,szMessEndOk          # message address
    call writeString           # display message
    call getchar
100:                           # final loop
    j 100b

/************************************/
/*     file include  Fonctions   */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../includeFunctions.s"
