# fichier include riscv assembly for rosetta code
# includeFunctions.s

/************************************/
/*       string write on connexion usb    */
/***********************************/
/* a0  String address */
writeString:                   # INFO: writeString
    addi    sp, sp, -8         # save registers on stack
    sw      ra, 0(sp)
    sw      s0, 4(sp)
    mv s0,a0                   # move string address
1:
    lbu a0,(s0)                # load one character
    beqz a0,100f               # end if zero
    call putchar               # character write
    add s0,s0,1                # increment address
    j 1b                       # and loop

100:                           # end function
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
/**********************************************/
/*   decimal conversion                       */
/**********************************************/
/* a0    value */
/* a1    conversion array address */
/* a0 return result size  */
.equ LGZONECONV,   20
conversion10:
    addi    sp, sp, -4
    sw      ra, 0(sp)
    li t1,LGZONECONV
    li t2,10               # divisor
1:
    rem t4,a0,t2           # division remainder by  10
    addi t4,t4,48          # convert to decimal
    add t5,a1,t1           # store character position
    sb t4,(t5)             # store byte
    div a0,a0,t2           # compute quotient
    beq a0,x0,2f           # compare to 0
    addi t1,t1,-1          # decrement store position
    bgt t1,x0,1b           # and loop if position is ok
2:
    li t2,0                # raz indice
    li t3,LGZONECONV
3:                         # loop to transfer result at begining conversion area
    add t5,a1,t1           # compute start position
    lb t4,(t5)             # load byte
    add t5,a1,t2           # compute new position
    sb t4,(t5)             # and store byte
    addi t2,t2,1           # increment indice
    addi t1,t1,1
    ble t1,t3,3b           # and loop if indice <= area size
    add t5,a1,t2           # increment final position
    sb x0,(t5)             # and store byte final zero
    mv a0,t2               # return size conversion

100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret
/***************************************************/
/*   register conversion  in décimal signed        */
/***************************************************/
/* a0 value   */
/* a1 result area address  size mini 12c */
/* a0 return result size  */
conversion10S:              # INFO: conversion10S
    addi    sp, sp, -8      # save registers
    sw      ra, 0(sp)
    li t6,'+'
    bge a0,x0,1f            # positive number ?
    li t6,'-'               # negative
    sub a0,x0,a0            # inversion
1:
    li t4,LENGTHDEC         # area size
    li t1,10                # divisor
2:
    remu t3,a0,t1           # remainder division by 10
    addi t3,t3,48           # conversion ascii
    add t2,t4,a1            # compute store indice
    sb t3,(t2)
    addi t4,t4,-1           # previous position
    divu a0,a0,t1           # division by 10
    bne a0,x0,2b
                            #  store signe in current position
    add t2,t4,a1
    sb t6,(t2)
	li t2,0
	li t3,LENGTHDEC
3:                         # loop copy result to area start
    add t5,a1,t4           # compute start position
    lb t6,(t5)             # load byte
    add t5,a1,t2           # compute new position
    sb t6,(t5)             # and store byte
    addi t2,t2,1           # increment indice
    addi t4,t4,1
    ble t4,t3,3b           # and loop if indice <= area size
    add t5,a1,t2           # increment final position
    sb x0,(t5)             # and store byte final zero
    mv a0,t2               # return size conversion

100:
    lw      ra, 0(sp)       # restaur registers
    addi    sp, sp, 8
    ret
