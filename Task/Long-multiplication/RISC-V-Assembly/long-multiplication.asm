# riscv assembly raspberry pico2 rp2350
# program longmulti.s
# connexion putty com3
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
/* for this file see risc-v task include a file */
.include "../../constantesRiscv.inc"
.equ BUFFERSIZE,   64

/****************************************************/
/* MACROS                   */
/****************************************************/
#.include "../ficmacrosriscv.inc"           # for debugging only

/***********************************************/
/* structures                                  */
/**********************************************/
/* Définition multi128 */
    .struct  0
multi128_N1:                      #   31-0
    .struct  multi128_N1 + 4
multi128_N2:                      #  63-32
    .struct  multi128_N2 + 4
multi128_N3:                      #  95-64
    .struct  multi128_N3 + 4
multi128_N4:                      #  127-96
    .struct  multi128_N4 + 4
multi128_N5:                      #  159-128
    .struct  multi128_N5 + 4
multi128_end:

/*******************************************/
/* INITIALED DATAS                    */
/*******************************************/
.data
szMessStart:         .asciz "Program riscv start.\r\n"
szMessEnd:           .asciz "\nProgram end OK.\r\n"
szCarriageReturn:    .asciz "\r\n"

szMessFactor:        .asciz "Factor = "
szMessResult:        .asciz "Result = "
szMessNegatif:       .asciz "\033[31mThe divisor must be positive !\033[0m\n"
szMessDivby0:        .asciz "\033[31mERROR: division by zero\033[0m \r\n"
szMessErrBuffer:     .asciz "\033[31mERROR: Conversion too low !!\033[0m \n"
szMessErrOverflow:   .asciz "\033[31mOverflow !!\033[0m \n"

.align 2
i128test1:           .int  0,0,1,0,0    # 2 power 64
/*******************************************/
/*  UNINITIALED DATA                    */
/*******************************************/
.bss
.align 2
sConvArea:       .skip BUFFERSIZE   # conversion buffer
i128Result1:     .skip multi128_end

/********************************...-..--*****/
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

    la a0,i128test1            # origin number
    la a1,sConvArea
    li a2,BUFFERSIZE
    call convertMultiForString # convert multi number to string
    mv s0,a0
    la a0,szMessFactor
    call writeString
    mv a0,s0
    call writeString
    la a0,szCarriageReturn
    call writeString

    la a0,i128test1           # factor 1
    la a1,i128test1           # factor 2
    la a2,i128Result1         # result
    call multiplierMulti128   # multiplication
    la a0,i128Result1         # result
    la a1,sConvArea
    li a2,BUFFERSIZE
    call convertMultiForString  # convert multi number to string
    mv s0,a0
    la a0,szMessResult
    call writeString
    mv a0,s0
    call writeString
    la a0,szCarriageReturn
    call writeString


    la a0,szMessEnd
    call writeString
    call getchar
100:                          # final loop
    j 100b

/***************************************************/
/*  multiplication multi128 by multi128             */
/***************************************************/
/* a0 contains address multi128 1   */
/* a1 contains address multi128 2   */
/* a2 contains address result multi128  */
/* a0 return address result (= a2)   */
multiplierMulti128:                # INFO: multiplierMulti128
    addi    sp,sp, -16          # reserve stack
    sw      ra,0(sp)
    sw      s0,4(sp)
    sw      s1,8(sp)
    sw      s2,12(sp)
    li t6,4                     # multi128 size
1:                              # init area result loop
    sh2add t0,t6,a2
    sw x0,(t0)
    addi t6,t6,-1
    bgez t6,1b
    li t5,0                     # indice loop 1
2:                              # loop items factor
    sh2add t0,t5,a0
    lw t1,(t0)
    li t4,0
    li t3,0
3:                              # loop item factor 2
    add t6,t4,t5                # compute result indice
    sh2add t0,t4,a1
    lw t2,(t0)                  # load a item factor 2
    mul s0,t1,t2
    mulhu s1,t1,t2              # multiply long 32 bits
    sh2add t0,t6,a2
    lw s2,(t0)                  # load previous item of result
    add s3,s2,s0                # add low part result multiplication
    sltu s4,s3,s2               # carry ?
    add s5,s3,t3                # add high part precedente
    sltu s3,s5,s3               # carry ?
    add t3,s1,s4                #  add carry TODO: a revoir
    add t3,t3,s3                # add carry 2
    sh2add t0,t6,a2
    sw s5,(t0)                  # store the sum in result
    addi t4,t4,1
    li t0,3
    blt t4,t0,3b                # and loop  2
    beqz t3,4f                  # high part ?
    addi t6,t6,1
    li t0,4
    bgt t6,t0,31f               # on last item ?
    sh2add t0,t6,a2
    sw t3,(t0)                  # no store high part in next item
    j 4f
31:
    la a0,szMessErrOverflow     # yes -> overflow
    call writeString
    j 100f
4:
    addi t5,t5,1                # increment indice 1
    li t0,3                     # end ?
    blt t5,t0,2b                # and loop 1
    mv a0,a2                    # result address

100:
    lw      ra,0(sp)
    lw      s0,4(sp)
    lw      s1,8(sp)
    lw      s2,12(sp)
    addi    sp,sp, 16
    ret
/***************************************************/
/*   conversion multi128 unsigned to string    */
/***************************************************/
/* a0 contains address multi128 */
/* a1 contains address buffer */
/* a2 contains buffer length */
convertMultiForString:                 # INFO: convertMultiForString
    addi    sp,sp, -16          # reserve stack
    sw      ra,0(sp)
    sw      s0,4(sp)
    sw      s1,8(sp)
    sw      s2,12(sp)
    addi sp,sp,- multi128_end  # reserve place to stack
    addi s1,sp,0                   # init address to quotient
    mv s0,a1                   # save address buffer
    li t3,0                    # init indice
1:
    sh2add t1,t3,a0
    lw t2,(t1)                 # load one part of number
    sh2add t1,t3,s1            # copy part on stack
    sw t2,(t1)
    addi t3,t3,1
    li t1,5
    blt t3,t1,1b
2:
    add t1,s0,a2
    sb x0,(t1)                # store final 0 in buffer end
    addi s2,a2,-1             # index buffer
3:
    mv a0,s1
    li a1,10
    call calculerModuloMultiEntier # compute modulo 10
    addi a0,a0,0x30             # convert result to character
    add t1,s2,s0
    sb a0,(t1)
    addi s2,s2,-1
    bltz s2,99f                 # buffer too low
    addi t1,s1,multi128_N1
    lw a0,(t1)
    bnez a0,3b                  # test if quotient = zero
    addi t1,s1,multi128_N2
    lw a0,(t1)
    bnez a0,3b
    addi t1,s1,multi128_N3
    lw a0,(t1)
    bnez a0,3b
    addi t1,s1,multi128_N4
    lw a0,(t1)
    bnez a0,3b
    addi t1,s1,multi128_N5
    lw a0,(t1)
    bnez a0,3b
    add a0,s0,s2                 # return address begin number in buffer
    addi a0,a0,1
    j 100f

99:
    la a0,szMessErrBuffer
    call writeString
    addi a0,x0,-1
100:
    addi sp,sp,multi128_end      # free place to stack
    lw      ra,0(sp)
    lw      s0,4(sp)
    lw      s1,8(sp)
    lw      s2,12(sp)
    addi    sp,sp, 16
    ret
/***************************************************/
/*    modulo  compute   unsigned                   */
/***************************************************/
/* a0 contains address multi128 */
/* a1 contains modulo (positive) */
/* a0 return  modulo              */
/* ATTENTION : le multientier origine est modifié et contient le quotient */
calculerModuloMultiEntier:   # INFO: calculerModuloMultiEntier
    addi    sp,sp, -16          # reserve stack
    sw      ra,0(sp)
    sw      s0,4(sp)
    sw      s1,8(sp)
    sw      s2,12(sp)
    blez a1,99f
    mv s1,a1               # save modulo
    li s2,4
    mv s0,a0               # multi128 address
    sh2add t6,s2,a0        # load last part of number in low part of 64 bits
    lw a0,(t6)
    li a1,0                # init higt part 64 bits
1:
    blez s2,2f
    mv a2,s1               # modulo
    call division64by32Opt
    sh2add t6,s2,s0
    sw a0,(t6)
    addi s2,s2,-1
    sh2add t6,s2,s0
    lw a0,(t6)
    mv a1,a2               # store remainder in high part of 64 bits
    j 1b
2:
    mv a2,s1               # modulo
    call division64by32Opt
    sw a0,(s0)             # stockage dans le 1er chunk
    mv a0,a2               # return remainder
    j 100f
99:
    la a0,szMessNegatif
    call writeString
100:
    lw      ra,0(sp)
    lw      s0,4(sp)
    lw      s1,8(sp)
    lw      s2,12(sp)
    addi    sp,sp, 16
    ret
/***************************************************/
/*   division number 64 bits in 2 registers by number 32 bits */
/*   unsigned                                      */
/***************************************************/
/* a0 contains lower part dividende   */
/* a1 contains upper part dividende   */
/* a2 contains divisor   */
/* a0 return lower part quotient    */
/* a1 return upper part quotient    */
/* a2 return remainder               */
/*correction dividende maxi ok  */
/* opti par reduction boucle 1  12/05/2026 */
division64by32Opt:               # INFO: division64by32Opt
    addi    sp, sp, -8           # save registres
    sw      ra, 0(sp)
    beqz a2,99f                  # divisor = 0 ?
    bnez a1,1f
    mv t0,a0
    divu a0,t0,a2
    mul t1,a0,a2
    sub a2,t0,t1
    j 100f
1:
    mv t0,a0          # save dividende
    mv t1,a1
    li t2,0           # init upper part divisor
    li t4,0           # init upper upper part divisor
    li a0,0           # init result
    li a1,0
    clz t3,a2         # init shift counter
    sll a2,a2,t3      # shift left divisor

2:                    # loop shift divisor
    bnez t4,4f        # upper uppert part new divisor <> 0 -> end loop
    bgtu  t2,t1,4f    # new upper divisor > upper dividende
    bltu  t2,t1,3f    # new upper divisor < upper dividende
    bgeu  a2,t0,4f    # new low divisor >= low dividende
3:
    sltz t4,t2        # bit 31 de upper divisor is 1 ?
    slli t2,t2,1      # shift left one bit upper divisor
    slt t5,a2,x0      # test bit 31 divisor
    or t2,t2,t5       # mov in bit 0 upper divisor
    slli a2,a2,1      # shift left one bit upper divisor
    addi t3,t3,1
    j 2b              # and loop

4:                    # loop 2
    slli a1,a1,1      # shift left 1 bit upper result
    slt t5,a0,x0      # test bit 31 lower result
    or a1,a1,t5       # move bit 31 lower on bit 0 upper
    slli a0,a0,1      # shift left 1 bit lower result
    bgtz t4,7f        # bit upper upper divisor is 1
    bgtu t2,t1,7f     # upper divisor > upper dividende
    bltu t2,t1,5f     # upper divisor < upper dividende
    bleu a2,t0,5f     # upper =   lower <=
    j 7f
5:
    sub t1,t1,t2      # sub upper
    ori a0,a0,1       # move 1 on bit 0 quotient
    sltu t5,t0,a2     # lower dividende < lower divisor
    sub t1,t1,t5      # sub carry
6:
    sub t0,t0,a2      # sub divisor from dividende lower
7:
    slli t5,t4,31     # shift bit 0 at position 31
    srli t4,t4,1      # shift right upper upper divisor
    slli t6,t2,31     # shit bit 0 to bit 31
    srli t2,t2,1      # shift right one bit upper divisor
    or t2,t2,t5       # bit 31 upper = bit 0 upper upper
    srli a2,a2,1      # shift right one bit lower divisor
    or a2,a2,t6       # bit 31 lower = bit 0 upper
    addi t3,t3,-1     # decrement shift counter
    bgez t3,4b        # if > 0 loop 2
    mv a2,t0          # remainder
    j 100f
99:
    la a0,szMessDivby0
    call writeString
    j 100f

100:
    lw      ra, 0(sp)
    addi    sp, sp, 8
    ret

/************************************/
/*     file include  Fonctions   */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../includeFunctions.s"

