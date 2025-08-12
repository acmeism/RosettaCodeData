 # riscv assembly raspberry pico2 rp2350
# program binaryDigits.s
# For construction see the riscv main page
# Exec by connexion putty com3
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
.equ LENGTHDEC,    12
.equ LENGTHBIN,    33
/*******************************************/
/* INITIALED DATAS                    */
/*******************************************/
.data
szMessStart:         .asciz "Program riscv start.\r\n"

szMessAffdeb:     .asciz "Decimal value : "
szMessAfffin:     .asciz " binary value : "
szCarriageReturn: .asciz " \r\n"
/*******************************************/
/*  UNINITIALED DATA                    */
/*******************************************/
.bss
sConvDec:      .skip LENGTHDEC
sConvBin:      .skip LENGTHBIN
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
    call tud_cdc_n_connected   # connexion usb by function sdk c++
    beqz a0,1b                 # return code = zero ?  loop

    la a0,szMessStart          # message address
    call writeString           # display string
    li a0,50
    call conversion
    li a0,-1
    call conversion
    li a0,1
    call conversion
    li a0,1<<30
    call conversion
    call getchar
100:                           # final loop
    j 100b
/************************************/
/*     conversion  and display        */
/***********************************/
/* a0 value   */
conversion:
    addi    sp, sp, -8
    sw      ra, 0(sp)          # save registers
    sw      s0, 4(sp)
    mv s0,a0
    la a0,szMessAffdeb
    call writeString           # display message
    mv a0,s0
    la a1,sConvDec
    call conversion10S
    call writeString           # display
    la a0,szMessAfffin
    call writeString           # display message
    mv a0,s0
    la a1,sConvBin
    call conversion2
    la a0,sConvBin
    call writeString           # display message
    la a0,szCarriageReturn
    call writeString           # display newline

100:
    lw      ra, 0(sp)          # restaur registers
    lw      s0, 4(sp)
    addi    sp, sp, 8
    ret
/************************************/
/*      binary  conversion          */
/***********************************/
/* a0 value   */
/* a1 result area address */
/*       size mini 33 character */
conversion2:                # INFO: conversion2
    addi    sp, sp, -8      # save registres
    sw      ra, 0(sp)
    li t2,0
    li t1,0
1:
    slt t3,a0,x0           # if negative  bit 31 is 1

    slli a0,a0,1           # shift left one bit
    add t0,a1,t1           # compute indice to store char in area
    addi t3,t3,'0'         # conversion byte to ascii char
    sb t3,(t0)             # store char in area
    addi t1,t1,1           # next position
    li t0,7                # for add a space separation
    beq t2,t0,4f
    li t0,15               # for add a space
    beq t2,t0,4f
    li t0,23               # for add a space
    beq t2,t0,4f
    j 5f

4:                         # store space
    li t3,' '
    add t0,a1,t1
    sb t3,(t0)
    addi t1,t1,1
5:
    addi t2,t2,1           # increment bit indice
    li t0,32               # maxi ?
    blt t2,t0,1b           # and loop

    add t0,a1,t1
    sb x0,(t0)             # final zero
100:
    lw      ra, 0(sp)
    addi    sp, sp, 8
    ret
/***************************************************/
/*   register conversion  in décimal signed        */
/***************************************************/
/* a0 value   */
/* a1 result area address  size mini 12c */
/* a0 return result start address  */
/* a1 return characters number in area */
conversion10S:              # INFO: conversion10S
    addi    sp, sp, -8      # save registers
    sw      ra, 0(sp)
    mv t5,a1                # begin store area
    li t6,'+'
    bge a0,x0,1f            # positive number ?
    li t6,'-'               # negative
    sub a0,x0,a0            # inversion
1:
    li t4,LENGTHDEC         # area size
    add t2,t4,t5
    sb x0,(t2)              # final zero
    addi t4,t4,-1           # position précedente
    li t1,10
2:
    remu t3,a0,t1           # reminder division by 10
    addi t3,t3,48           # conversion ascii
    add t2,t4,t5            # compute store indice
    sb t3,(t2)
    addi t4,t4,-1           # position précedente
    divu a0,a0,t1           #  division by 10
    bne a0,x0,2b
                            #  store signe in current position
    add t2,t4,t5
    sb t6,(t2)
3:
    add a0,t4,t5            # return store area begin address
    li t0,LENGTHDEC         # and size
    sub a1,t0,t4

100:
    lw      ra, 0(sp)       # restaur registers
    addi    sp, sp, 8
    ret
/************************************/
/*       string write on connexion usb    */
/***********************************/
/* a0  String address */
writeString:                   # INFO: writeString
    addi    sp, sp, -8         # save registers on stack
    sw      ra, 0(sp)
    sw      s0, 4(sp)
    mv s0,a0                   # save address
1:
    lbu a0,(s0)                # load one character
    beqz a0,100f               # end if zero
    call __wrap_putchar        # character write
    add s0,s0,1                # increment address
    j 1b                       # and loop
100:
    lw      ra, 0(sp)          # restaur registers
    lw      s0, 4(sp)
    addi    sp, sp, 8
    ret
