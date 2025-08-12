# riscv assembly raspberry pico2 rp2350
# program adrvariable.s
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
.align 2
tabValues:      .int 1,2,3,4

/*******************************************/
/*  UNINITIALED DATA                    */
/*******************************************/
.bss
.align 2
sConvArea:       .skip 24
ivalue1:         .skip 4

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

    la t1,ivalue1              # variable address
    lw a0,(t1)                 # load word value
    call displayResult
    la t1,ivalue1              # variable address
    li t0,12345                # new value
    sw t0,(t1)                 # store word value
    la t1,ivalue1              # variable address
    lw a0,(t1)                 # load value for control
    call displayResult
    la t1,tabValues            # load array address
    lw a0,8(t1)                # load value at byte 8 of array
    call displayResult
    la t1,tabValues            # load array address
    li t2,3                    # init index value
    slli t2,t2,2               # multiply index by 5 (integer size)
    add t2,t2,t1               # add offset to array address
    lw a0,(t2)                 # load value of index
    call displayResult

    call getchar
100:                           # final loop
    j 100b

/**********************************************/
/*   displayResult                       */
/**********************************************/
/* a0    value */
.equ LGZONECONV,   20
displayResult:
    addi    sp, sp, -4         # reserve stack
    sw      ra, 0(sp)
    la a1,sConvArea            # conversion result address
    call conversion10          # conversion decimal
    la a0,sConvArea            # message address
    call writeString           # display message
    la a0,szCariageReturn
    call writeString
100:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    ret

/**********************************************/
/*   decimal conversion                       */
/**********************************************/
/* a0    value */
/* a1    conversion array address */
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
/************************************/
/*     file include  Fonctions   */
/***********************************/
/* for this file see risc-v task include a file */
.include "../../includeFunctions.s"
