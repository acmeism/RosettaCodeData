# riscv assembly raspberry pico2 rp2350
# program branch.s
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
szMessStart:         .asciz "Program riscv start.\r\n"
szMessEndOk:         .asciz "Program riscv end OK.\r\n"
szCariageReturn:     .asciz "\r\n"

szMessResult:         .asciz "loop indice : "
szMessage1:           .asciz "Display to routine call by register\n"
szMessage2:           .asciz "Equal to zero.\n"
szMessage3:           .asciz "Not equal to zero.\n"
szMessage4:           .asciz "loop start\n"
szMessage5:           .asciz "No executed.\n"

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
    call writeString           # pseudocode for branch and link
	                           # return here after routine execution
	
	la a0,szMessStart          # message address
    jal ra, writeString        #  branch and link (idem call)
	
	j label1                   # branch unconditional to label
	la a0,szMessage5           # this instruction is never executed
    call writeString           # and this
label1:
    li t0,0
	beqz t0,label2             # test if value on t0 is zero
	la a0,szMessage2
	call writeString
	j label3                   # end branch test
label2:                        # else
	la a0,szMessage3
	call writeString	
label3:                        # end if else
	la a0,szMessage4
	call writeString
	li s0,0                    # indice
	li s1,5                    # maxi
1:                             # begin loop
    mv a0,s0                   # indice
	la a1,sConvArea
	call conversion10          # conversion to ascii
	la a0,szMessResult
	call writeString
    la a0,sConvArea            # and display
	call writeString
	la a0,szCariageReturn
    call writeString
	addi s0,s0,1               # increment indice
	blt  s0,s1,1b              # branch for loop if lower, branch before
	
	j 2f                       # branch to forward
	la a0,szMessage5           # this instruction is never executed
    call writeString           # and this	
2:
    la a0,szMessage1
    la t0,writeString
    jalr ra,t0                 # call address function in t0
	
    la a0,szMessEndOk          # message address
    call writeString           # display message
    call getchar
100:                           # final loop
    j 100b

/************************************/
/*     file include  Fonctions   */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../../includeFunctions.s"
