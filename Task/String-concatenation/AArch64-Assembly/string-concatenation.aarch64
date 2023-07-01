/* ARM assembly AARCH64 Raspberry PI 3B */
/*  program concatStr64.s   */

/*******************************************/
/* Constantes file                         */
/*******************************************/
/* for this file see task include a file in language AArch64 assembly*/
.include "../includeConstantesARM64.inc"
/*******************************************/
/* Initialized data                        */
/*******************************************/
.data
szMessFinal:   .asciz "The final string is \n"

szString:            .asciz "Hello "
szString1:           .asciz " the world. \n"
/*******************************************/
/* UnInitialized data                      */
/*******************************************/
.bss
szFinalString:   .skip 255
/*******************************************/
/*  code section                           */
/*******************************************/
.text
.global main
main:
                                   // load string
    ldr x1,qAdrszString
    ldr x2,qAdrszFinalString
    mov x4,0
1:
    ldrb w0,[x1,x4]                // load byte of string
    strb w0,[x2,x4]
    cmp x0,0                       // compar with zero ?
    add x3,x4,1
    csel x4,x3,x4,ne               // if x0 <> 0 x4 = x4 +1 sinon x4
    bne 1b
    ldr x1,qAdrszString1
    mov x3,0
2:
    ldrb w0,[x1,x3]                // load byte of string 1
    strb w0,[x2,x4]
    cmp x0,0                       // compar with zero ?
    add x5,x4,1
    csel x4,x5,x4,ne
    add x5,x3,1
    csel x3,x5,x3,ne
    bne 2b
    mov x0,x2                      // display final string
    bl affichageMess
100:                               // standard end of the program */
    mov x0,0                       // return code
    mov x8,EXIT                    // request to exit program
    svc 0                          // perform the system call
qAdrszString:             .quad szString
qAdrszString1:            .quad szString1
qAdrszFinalString:        .quad szFinalString
qAdrszMessFinal:          .quad szMessFinal
/********************************************************/
/*        File Include fonctions                        */
/********************************************************/
/* for this file see task include a file in language AArch64 assembly */
.include "../includeARM64.inc"
