# riscv assembly raspberry pico2 rp2350
# program compstring.s
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
szCariageReturn:     .asciz "\r\n"
szMessStringEqu:     .asciz "The strings are equals.\n"
szMessStringNotEqu:  .asciz "The strings are not equals.\n"

szString1:           .asciz "ABCDE"
szString2:           .asciz "ABCDE"
szString3:           .asciz "ABCFG"
szString4:           .asciz "ABC"
szString5:           .asciz "abcde"
.align 2

/*******************************************/
/*  UNINITIALED DATA                    */
/*******************************************/
.bss
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
	
	la a0,szString1
    la a1,szString2
    call Comparaison
	
	la a0,szString1
    la a1,szString3
    call Comparaison

    la a0,szString1
    la a1,szString4
    call Comparaison
	
    # case sensitive comparisons ABCDE et abcde
    la a0,szString1
    la a1,szString5
    call Comparaison
	
	# case insensitive comparisons ABCDE et abcde
    la a0,szString1
    la a1,szString5
    call comparStringsInsensitive
	bnez a0,1f
    la a0,szMessStringEqu
    call writeString           # display message
    j 2f
1:
    la a0,szMessStringNotEqu
    call writeString           # display message		
2:
    call getchar
100:                           # final loop
    j 100b

/*********************************************/
/* comparaison                               */
/*********************************************/
/* a0 contains address String 1           */
/* a1 contains address String 2         */
Comparaison:
    addi    sp, sp, -4
    sw      ra, 0(sp)
    call comparStrings
	bnez a0,1f

    la a0,szMessStringEqu
    call writeString           # display message
    j 100f
1:
    la a0,szMessStringNotEqu
    call writeString           # display message
100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret
/************************************/	
/* Strings case sensitive comparisons  */
/************************************/	
/* a0 et ra1 contains the address of strings */
/* return 0 in a0 if equals */
/* return -1 if string a0 < string a1 */
/* return 1  if string a0 > string a1 */
comparStrings:             # INFO: comparStrings
    addi    sp, sp, -4
    sw      ra, 0(sp)
    li t0,0
1:
    add t1,t0,a0
    lb t1,(t1)
    add t2,t0,a1
    lb t2,(t2)
    beq t1,t2,2f
    bgt t1,t2,3f
    blt t1,t2,4f
2:                         # egal
    addi t0,t0,1
    bne t1,x0,1b           # fin chaine
    li a0,0                # egalité
    j 100f
3:                         # plus haut
    li a0,1
    j 100f
4:                         # plus bas
    li a0,-1
    j 100f
100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret
/************************************/	
/* Strings case insensitive comparisons  */
/************************************/	
/* a0 et a1 contains the address of strings */
/* return 0 in a0 if equals */
/* return -1 if string a0 < string a1 */
/* return 1  if string a0 > string a1 */
comparStringsInsensitive:    # INFO: comparStringsInsensitive
    addi    sp, sp, -4
    sw      ra, 0(sp)
    li t0,0
1:
    add t1,t0,a0
    lb t1,(t1)
	# majuscules --> minuscules  byte string 1
	li t3,65
    blt t1,t3,2f
    li t3,90
    bgt t1,t3,2f
    addi t1,t1,32
2:	
    add t2,t0,a1
    lb t2,(t2)
	# majuscules --> minuscules  byte string 2
	li t3,65
    blt t2,t3,3f
    li t3,90
    bgt t2,t3,3f
    addi t2,t2,32
3:		
	
    beq t1,t2,4f
    bgt t1,t2,5f
    blt t1,t2,6f
4:                         # egal
    addi t0,t0,1
    bne t1,x0,1b           # fin chaine
    li a0,0                # egalité
    j 100f
5:                         # plus haut
    li a0,1
    j 100f
6:                         # plus bas
    li a0,-1
    j 100f

100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret

/************************************/
/*     file include  Fonctions   */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../includeFunctions.s"
