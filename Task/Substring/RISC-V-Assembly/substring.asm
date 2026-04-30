# riscv assembly raspberry pico2 rp2350
# program substring.s
# connexion putty com3
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
/* for this file see risc-v task include a file */
.include "../../constantesRiscv.inc"
.equ BUFFERSIZE,      200
/*******************************************/
/* INITIALED DATAS                    */
/*******************************************/
.data
szMessStart:         .asciz "Program riscv start.\r\n"
szMessEndOk:         .asciz "Program riscv end OK.\r\n"
szCariageReturn:     .asciz "\r\n"

szMessErrorString:   .asciz "Error buffer size."
szMessString:        .asciz "Result : "
szString1:           .asciz "abcdefghijklmnopqrstuvwxyz"
szStringStart:       .asciz "cdefg"

.align 2
/*******************************************/
/*  UNINITIALED DATA                    */
/*******************************************/
.bss
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

    la a0,szMessStart          # message address
    call writeString           # display message
	
	la a0,szString1            # address  string 1
	la a1,sBuffer              # result buffer
	li a2,BUFFERSIZE           # buffer size
	li a3,10                   # location
	li a4,4                    # size
    call subStringNbChar       #
    bltz a0,100f               # error
	
	la a0,sBuffer              # result buffer
    call writeString           # display message
	la a0,szCariageReturn
	call writeString
	
	la a0,szString1            # address  string 1
	la a1,sBuffer              # result buffer
	li a2,BUFFERSIZE           # buffer size
	li a3,20                   # location
	li a4,1000                 # size to end string
    call subStringNbChar       #
    bltz a0,100f               # error
		
	la a0,sBuffer              # result buffer
    call writeString           # display message
	la a0,szCariageReturn
	call writeString
	
	la a0,szString1            # address  string 1
	la a1,sBuffer              # result buffer
	li a2,BUFFERSIZE           # buffer size
    call subStringMinus       #
    bltz a0,100f               # error
	
	la a0,sBuffer              # result buffer
    call writeString           # display message
	la a0,szCariageReturn
	call writeString
	
	la a0,szString1            # address  string 1
	la a1,sBuffer              # result buffer
	li a2,BUFFERSIZE           # buffer size
	li a3,'c'                  # character
	li a4,5                    # size to extract string
	call subStringStChar      # starting from a known character within the string and of m length
    bltz a0,100f               # error
	
	la a0,sBuffer              # result buffer
    call writeString           # display message
	la a0,szCariageReturn
	call writeString
	
	la a0,szString1            # address  string 1
	la a1,sBuffer              # result buffer
	li a2,BUFFERSIZE           # buffer size
	la a3,szStringStart        # string search address
	li a4,5                    # size to extract string
	call subStringStString     # starting from a substring within the string and of m length
    li t0,-2
	beq a0,t0,100f
	
	la a0,sBuffer              # result buffer
    call writeString           # display message
	la a0,szCariageReturn
	call writeString
	
    la a0,szMessEndOk          # message address
    call writeString           # display message
    call getchar
100:                           # final loop
    j 100b
/***************************************************/
/*    extract n characters at location              */
/***************************************************/
# a0 contains string
# a1 contains result area
# a2 contains size area result
# a3 contains location
# a4 contains length to extract
subStringNbChar:
    addi    sp, sp, -4         # reserve stack
    sw      ra, 0(sp)          # save  registers              @ save  registers
    li t1,0                    # init counter
	li t2,0
1:                             # loop string1
	add t0,a0,t1               # compute byte address
    lbu t3,(t0)                # load byte string
	beqz t3,3f                 # zero final
	bge t1,a3,2f               # location ?
	addi t1,t1,1               # no -> loop
	j 1b
2:	
	add t0,a1,t2               # compute byte address result
	sb t3,(t0)                 # store byte
	addi t2,t2,1               # increment buffer indice
	bgt t2,a2,99f              # error ?
	bge t2,a4,3f               # end count extract ?
	addi t1,t1,1               # no -> loop
	j 1b
3:
	add t0,a1,t2               # compute byte address
    sb x0,(t0)                 # store zero final
    mv a0,t2                   # return extract length	
	j 100f

99:                            # error
    la a0,szMessErrorString
	call writeString           # display message
	li a0,-1                   # error
100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret
/***************************************************/
/*    whole string minus last character               */
/***************************************************/
# a0 contains string
# a1 contains result area
# a2 contanis size area result
subStringMinus:
    addi    sp, sp, -4         # reserve stack
    sw      ra, 0(sp)          # save  registers              @ save  registers
    li t1,0                    # init counter
	li t2,0
1:                             # loop string1
	add t0,a0,t1               # compute byte address
    lbu t3,(t0)                # load byte string
	beqz t3,2f                 # zero final
	add t0,a1,t2               # compute byte address result
	sb t3,(t0)                 # store byte
	addi t2,t2,1               # increment buffer indice
	bgt t2,a2,99f              # error ?
	addi t1,t1,1               # no -> loop
	j 1b
2:
    addi t2,t2,-1
	add t0,a1,t2               # compute byte address
    sb x0,(t0)                 # store zero final
    mv a0,t2                   # return extract length	
	j 100f

99:                            # error
    la a0,szMessErrorString
	call writeString           # display message
	li a0,-1                   # error
100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret
/***************************************************/
/*    extract n characters at location first character              */
/***************************************************/
# a0 contains string
# a1 contains result area
# a2 contanis size area result
# a3 contains character
# a4 contains length to extract
subStringStChar:
    addi    sp, sp, -4         # reserve stack
    sw      ra, 0(sp)          # save  registers              @ save  registers
    li t1,0                    # init counter
	li t2,0
1:                             # loop string1
	add t0,a0,t1               # compute byte address
    lbu t3,(t0)                # load byte string
	beqz t3,3f                 # zero final
	beq t3,a3,2f               # character ?
	addi t1,t1,1               # no -> loop
	j 1b
2:	
	add t0,a0,t1               # compute byte address
    lbu t3,(t0)                # load byte string
	beqz t3,3f                 # zero final
	add t0,a1,t2               # compute byte address result
	sb t3,(t0)                 # store byte
	addi t2,t2,1               # increment buffer indice
	bgt t2,a2,99f              # error ?
	bge t2,a4,3f               # end count extract ?
	addi t1,t1,1               # no -> loop
	j 2b
3:
	add t0,a1,t2               # compute byte address
    sb x0,(t0)                 # store zero final
    mv a0,t2                   # return extract length	
	j 100f

99:                            # error
    la a0,szMessErrorString
	call writeString           # display message
	li a0,-1                   # error
100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret
/***************************************************/
/*    extract n characters at location search string              */
/***************************************************/
# a0 contains string
# a1 contains result area
# a2 contanis size area result
# a3 contains adresse search string
# a4 contains length to extract
subStringStString:
    addi    sp, sp, -12        # reserve stack
    sw      ra,0(sp)           # save  registers
	sw      s0,4(sp)
	sw      s1,8(sp)
	mv s0,a0
	sb x0,(a1)                 # store 0 final in result area
	mv s1,a1
	mv a1,a3
	call searchSubString
	bltz a0,100f               # not found
    mv t1,a0                   # init counter
	li t2,0
1:                             # loop string1
	add t0,s0,t1               # compute byte address
    lbu t3,(t0)                # load byte string
	beqz t3,2f                 # zero final
	add t0,s1,t2               # compute byte address result
	sb t3,(t0)                 # store byte
	addi t2,t2,1               # increment buffer indice
	bgt t2,a2,99f              # error ?
	bge t2,a4,2f               # end count extract ?
	addi t1,t1,1               # no -> loop
	j 1b
2:
	add t0,s1,t2               # compute byte address
    sb x0,(t0)                 # store zero final
    mv a0,t2                   # return extract length	
	j 100f
10:
    li a0,-1
    j 100f
99:                            # error
    la a0,szMessErrorString
	call writeString           # display message
	li a0,-1                   # error
100:
    lw      ra, 0(sp)
	lw      s0,4(sp)
    lw      s1,8(sp)
    addi    sp, sp, 12
    ret	
/***************************************************/
/*    search string in string              */
/***************************************************/
# a0 contains string
# a1 contains search string
# a0 returns indice if find or -1 if not or -2 if error
searchSubString:
    addi    sp, sp, -4         # reserve stack
    sw      ra, 0(sp)          # save  registers              @ save  registers
	li t3,0
1:
    li t5,-1                   # indice find ok
    li t1,0                    # init counter
	add t0,a1,t1               # compute byte address
    lbu t2,(t0)                # load byte string
	beqz t2,99f                # empty string -> error
2:                             # loop to copy string begin
	add t0,a0,t3               # compute byte address string 1
    lbu t4,(t0)                # load byte string
	beqz t4,5f                 # zero final ?
	bne t4,t2,3f               # not equal
	addi t5,t5,1               # increment indice find
	addi t3,t3,1               # increment indice string
	addi t1,t1,1               # increment indice search string
	add t0,a1,t1               # compute byte address
    lbu t2,(t0)                # load byte string
	beqz t2,6f                 # end search string -> found
	j 2b                       # else loop
3:
    bltz t5,4f                 # not characters precedent found ?
	sub t3,t3,t5               # yes raz position search
	j 1b                       # and restart search at begining
4:
    addi t3,t3,1               # increment indice
	j 2b                       # and loop other character
5:
    li a0,-1                   # not found
	j 100f	
6:
	mv a0,t3                   # return end indice
	j 100f
99:                            # error
    la a0,szMessErrorString
	call writeString           # display message
	li a0,-2                   # error
100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret	
/************************************/
/*     file include  Fonctions   */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../includeFunctions.s"
