# riscv assembly raspberry pico2 rp2350
# program matchstring.s
# connexion putty com3
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
/* for this file see risc-v task include a file */
.include "../../constantesRiscv.inc"
/*******************************************/
/* INITIALED DATAS                    */
/*******************************************/
.data
szMessStart:         .asciz "Program riscv start.\r\n"
szMessEndOk:         .asciz "Program riscv end OK.\r\n"
szCariageReturn:     .asciz "\r\n"

szMessErrorString:       .asciz "Error search string empty "
szMessFound:             .asciz "String found. \n"
szMessFoundPos:          .asciz "String found at position "
szMessNotFound:          .asciz "String not found. \n"
szString:                .asciz "abcdefghijklmnopqrstuvwxyz"
szString2:               .asciz "abc"
szStringStart:           .asciz "abcd"
szStringEnd:             .asciz "xyz"
szStringStart2:          .asciz "abcd"
szStringEnd2:            .asciz "xabc"
szString3:               .asciz "abcdefddddehdezdedede"
szStringSer:             .asciz "deh"
szCarriageReturn:        .asciz "\n"

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
	
	la a0,szString             # address input string
    la a1,szStringStart        # address search string
    call searchStringDeb       # Determining if the first string starts with second string
    blez a0,1f

    la a0,szMessFound          # display message
    call writeString
    j 2f
1:
    la a0,szMessNotFound
    call writeString
2:
	
	la a0,szString             # address input string
    la a1,szStringEnd        # address search string
    call searchStringEnd       # Determining if the first string end with second string
    blez a0,3f

    la a0,szMessFound          # display message
    call writeString
    j 4f
3:
    la a0,szMessNotFound
    call writeString
4:	

	la a0,szString             # address input string
    la a1,szStringEnd          # address search string
    call searchSubString       # search string
    bltz a0,5f                 # < 0

    la a1,sConvArea
	call conversion10
    la a0,szMessFoundPos       # display message
    call writeString
	la a0,sConvArea            # display position
	call writeString
	la a0,szCarriageReturn
	call writeString
	
    j 6f
5:
    la a0,szMessNotFound
    call writeString
6:	

	la a0,szString3             # address input string
    la a1,szStringSer          # address search string
    call searchSubString       # search string
    bltz a0,7f                 # < 0

    la a1,sConvArea
	call conversion10
    la a0,szMessFoundPos       # display message
    call writeString
	la a0,sConvArea            # display position
	call writeString
	la a0,szCarriageReturn
	call writeString
	
    j 8f
7:
    la a0,szMessNotFound
    call writeString
8:	

    la a0,szMessEndOk          # message address
    call writeString           # display message
    call getchar
100:                           # final loop
    j 100b
/***************************************************/
/*    search string at beguining               */
/***************************************************/
# a0 contains string
# a1 contains search string
# a0 returns 1 if find or 0 if not or -1 if error
searchStringDeb:
    addi    sp, sp, -4         # reserve stack
    sw      ra, 0(sp)          # save  registers              @ save  registers
    li t1,0                    # init counter
	add t0,a1,t1               # compute byte address
    lbu t2,(t0)                # load byte string
	beqz t2,99f                # empty string -> error
1:                             # loop to copy string begin
	add t0,a0,t1               # compute byte address string 1
    lbu t3,(t0)                # load byte string
	beqz t3,2f                 # zero final ? -> not found
	bne t3,t2,2f               # not equal
	addi t1,t1,1
	add t0,a1,t1               # compute byte address search string
    lbu t2,(t0)                # load byte string
	bnez t2,1b                 # not end search string -> loop
	li a0,1                    # else string founded
	j 100f
2:
    li a0,0
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
/*    search string at end first string               */
/***************************************************/
# a0 contains string
# a1 contains search string
# a0 returns 1 if find or 0 if not or -1 if error
searchStringEnd:
    addi    sp, sp, -4         # reserve stack
    sw      ra, 0(sp)          # save  registers              @ save  registers
    li t1,0                    # init counter
1:	                           # loop to search end search string
	add t0,a1,t1               # compute byte address
    lbu t2,(t0)                # load byte string
	beqz t2,2f                 # zero final
	addi t1,t1,1               # increment indice
	j 1b                       # and loop
2:
    beqz t1,99f                # empty string -> error
	li t3,0
3:                             # loop to search end string
	add t0,a0,t3               # compute byte address string 1
    lbu t4,(t0)                # load byte string
	beqz t4,4f                 # zero final ?
	addi t3,t3,1
	j 3b
4:
    beqz t3,7f                # empty string -> not found
5:
    addi t1,t1,-1
	bltz t1,6f                # begin search string -> found
	add t0,a1,t1               # compute byte address
    lbu t2,(t0)                # load byte string
    addi t3,t3,-1
	bltz t3,7f                # begin  string -> not found
	add t0,a0,t3               # compute byte address string 1
    lbu t4,(t0)                # load byte string
	bne t4,t2,7f              # not equal
	j 5b
6:
	li a0,1                    # string founded
	j 100f
7:                             # string not found
    li a0,0
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
/*    search string in string              */
/***************************************************/
# a0 contains string
# a1 contains search string
# a0 returns 1 if find or 0 if not or -1 if error
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
	#addi t3,t3,1
	j 1b                       # and restart search at begining
4:
    addi t3,t3,1               # increment indice
	j 2b                       # and loop other character
5:
    li a0,-1                   # not found
	j 100f
	
6:
    sub a0,t3,t5               # string found
	addi a0,a0,-1
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
