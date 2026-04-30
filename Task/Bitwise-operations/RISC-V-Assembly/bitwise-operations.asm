 # riscv assembly raspberry pico2 rp2350
# program bitwise.s
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
szMessReg0:          .asciz "Register s0:\r\n"
szMessReg1:          .asciz "Register s1:\r\n"
szMessAnd:           .asciz "And result:\r\n"
szMessOr:            .asciz "Or result :\r\n"
szMessXor:           .asciz "Xor result :\r\n"
szMessNot:           .asciz "Not result :\r\n"
szMessNeg:           .asciz "Neg result :\r\n"
szMessBset:          .asciz "Set single bit result :\r\n"
szMessSll:           .asciz "Shift left result :\r\n"
szMessSrl:           .asciz "Shift right result :\r\n"
szMessSra:           .asciz "Shift right arithmetic result :\r\n"
szMessRol:           .asciz "Rotation left result :\r\n"
szMessRor:           .asciz "Rotation right result :\r\n"
szMessBclr:          .asciz "Clear single bit result :\r\n"
szMessBext:          .asciz "Extraction single bit result :\r\n"
szMessBinv:          .asciz "Inversion single bit result :\r\n"
szMessBrev:          .asciz "Bit-reverse within each byte result :\r\n"
szMessClz:           .asciz "Count leading zeroes result :\r\n"
szMessCtz:           .asciz "Count trailing zeroes result :\r\n"
szMessCpop:          .asciz "Population count result :\r\n"
szMessPack:          .asciz "Pack two halfwords into one word result :\r\n"
szMessPackh:         .asciz "Pack two byte into one halfword result :\r\n"
szMessZip:           .asciz "Zip result :\r\n"
szMessUnzip:         .asciz "Unzip result :\r\n"
.align 2

/*******************************************/
/*  UNINITIALED DATA                    */
/*******************************************/
.bss
.align 2
sConvArea:       .skip 24
sConvBinaire:    .skip 36
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
	
	la a0,szMessReg0           # message address
    call writeString           # display message
	li s0,0b1100
	mv a0,s0
	call displayResult
	
    la a0,szMessReg1           # message address
    call writeString           # display message
	li s1,0b1001
	mv a0,s1
    call displayResult
	
    la a0,szMessAnd            # and
    call writeString           # display message
    andi a0,s0,0b1001          # and immediat value
    call displayResult
    and a0,s0,s1               # register and
    call displayResult
	andn a0,s0,s1              # register and and not
    call displayResult

    la a0,szMessOr             # or
    call writeString           # display message
    ori a0,s0,0b1001           # or immediat value
    call displayResult
    or a0,s0,s1                # or register
    call displayResult
    orn a0,s0,s1               # or and not register
    call displayResult
	orc.b a0,s0                # OR-combine of bits within each byte. Generates a mask of nonzero bytes
    call displayResult
	
	
    la a0,szMessXor            # xor
    call writeString           # display message
    xori a0,s0,0b1001          # xor immediat value
    call displayResult
    xor a0,s0,s1               # xor register
    call displayResult
	xnor a0,s0,s1              # Bitwise XOR with inverted operand. Equivalently, bitwise NOT of bitwise XOR
    call displayResult

    la a0,szMessNot            # not
    call writeString           # display message
	not a0,s0                  # not
	call displayResult
	
	la a0,szMessNeg            # negation
    call writeString           # display message
	neg a0,s0                  # negation
	call displayResult
	
	la a0,szMessSll            # shift left
    call writeString           # display message
    slli a0,s0,11              # shift left immediat value
    call displayResult
	li t0,5
    sll a0,s0,t0               # shift left register
    call displayResult
	
    la a0,szMessSrl            # shift right
    call writeString           # display message
    srli a0,s0,1               # shift right immediat value
    call displayResult
	li t0,5
    srl a0,s0,t0               # shift right register
    call displayResult
	
	la a0,szMessSra            # Shift right, arithmetic
    call writeString           # display message
    srai a0,s0,1               # shift right arithmetic immediat value
    call displayResult
	li t0,5
	li t1,0b10000000000000001100000000000000
    sra a0,t1,t0               # shift right arithmetic register
    call displayResult
	
    la a0,szMessRol            # rotation left
    call writeString           # display message
	li t0,5
    rol a0,s0,t0               # rotation left register
    call displayResult
	
    la a0,szMessRor            # rotation right
    call writeString           # display message
    rori a0,s0,10              # rotation right immediat value
    call displayResult
	li t0,5
    ror a0,s0,t0               # rotation right register
    call displayResult
	
	la a0,szMessBclr           # Clear single bit.
    call writeString           # display message
    bclri a0,s0,3              # Clear single bit. immediat value
    call displayResult
	li t0,2
    bclr a0,s0,t0              # Clear single bit. register
    call displayResult
	
    la a0,szMessBext           # Extraction single bit.
    call writeString           # display message
    bexti a0,s0,3              # Extraction  single bit. immediat value
    call displayResult
	li t0,2
    bext a0,s0,t0              # Extraction  single bit. register
    call displayResult
	
	la a0,szMessBinv           # Inversion single bit.
    call writeString           # display message
    binvi a0,s0,3              # Inversion bit. immediat value
    call displayResult
	li t0,2
    binv a0,s0,t0              # Inversion single bit. register
    call displayResult
	
	la a0,szMessBset           # Set single bit
    call writeString           # display message
    bseti a0,s0,8              # Set single bit (immediate).
    call displayResult
	li t0,17
    bset a0,s0,t0              # Set single bit
    call displayResult

	la a0,szMessClz            # Count leading zeroes (starting from MSB, searching LSB-ward).
    call writeString           # display message
    clz a0,s0                  #
    call displayResultD
	
	la a0,szMessCtz            # Count trailing zeroes (starting from LSB, searching MSB-ward).
    call writeString           # display message
    ctz a0,s0                  #
    call displayResultD
	
    la a0,szMessCpop           # Population count
    call writeString           # display message
    cpop a0,s0                 #
    call displayResultD
	
    la a0,szMessBrev           # Bit-reverse within each byte
    call writeString           # display message
    brev8 a0,s0                #
    call displayResult

	la a0,szMessPack           # Pack two halfwords into one word
    call writeString           # display message
	li t0,0x1234
	li t1,0x5678
    pack a0,t1,t0              #
    call displayResultHex
	
    la a0,szMessPackh          # Pack two halfwords into one word
    call writeString           # display message
	li t0,0x12
	li t1,0x34
    packh a0,t1,t0             #
    call displayResultHex
	
	la a0,szMessZip            # Interleave upper/lower half of register into odd/even bits of result
    call writeString           # display message
    zip s2,s0
    mv a0,s2	#
    call displayResult
	
    la a0,szMessUnzip          # Deinterleave odd/even bits of register into upper/lower half of result
    call writeString           # display message
    unzip a0,s2                #
    call displayResult
    call getchar
100:                           # final loop
    j 100b

/**********************************************/
/*   display binary Result                       */
/**********************************************/
/* a0    value */
.equ LGZONECONV,   20
displayResult:
    addi    sp, sp, -4         # reserve stack
    sw      ra, 0(sp)
    la a1,sConvBinaire         # conversion result address
    call conversion2           # binary conversion
    la a0,sConvBinaire         # message address
    call writeString           # display message
    la a0,szCariageReturn
    call writeString
100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret
/**********************************************/
/*   display Result  décimal                     */
/**********************************************/
/* a0    value */
.equ LGZONECONV,   20
displayResultD:
    addi    sp, sp, -4         # reserve stack
    sw      ra, 0(sp)
    la a1,sConvArea            # conversion result address
    call conversion10           # binary conversion
    la a0,sConvArea         # message address
    call writeString           # display message
    la a0,szCariageReturn
    call writeString
100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret
/**********************************************/
/*   display hexadecimal result                       */
/**********************************************/
/* a0    value */
.equ LGZONECONV,   20
displayResultHex:
    addi    sp, sp, -4         # reserve stack
    sw      ra, 0(sp)
    la a1,sConvArea            # conversion result address
    call conversion16         # conversion decimal
    la a0,sConvArea            # message address
    call writeString           # display message
    la a0,szCariageReturn
    call writeString
100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret

/************************************/
/*     file include  Fonctions   */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../includeFunctions.s"
