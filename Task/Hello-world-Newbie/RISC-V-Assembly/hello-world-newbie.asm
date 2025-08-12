# riscv assembly raspberry pico2
# program hello.s
# connexion putty com3
/*********************************************/
/*           CONSTANTES                      */
/********************************************/

/*******************************************/
/* INITIALED DATAS                    */
/*******************************************/
.data
szMessHello:         .asciz "Hello world.\r\n"
szMessStart:         .asciz "Program riscv start.\r\n"
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
    call tud_cdc_n_connected
    beqz a0,1b                 # return code = zero ?

    la a0,szMessStart          # message address
    call writeString           # display message
    la a0,szMessHello          # message address
    call writeString           # display message

100:                           # final loop
    j 100b
/************************************/
/*       string write on connexion usb    */
/***********************************/
/* a0  String address */
writeString:                   # INFO: writeString
    addi    sp, sp, -8         # save registers on stack
    sw      ra, 0(sp)
    sw      s0, 4(sp)
    mv s0,a0                   # move address
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
