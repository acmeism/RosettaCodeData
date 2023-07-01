/* ARM assembly AARCH64 Raspberry PI 3B */
/*  program appendstr64.s   */

/*******************************************/
/* Constantes file                         */
/*******************************************/
/* for this file see task include a file in language AArch64 assembly*/
.include "../includeConstantesARM64.inc"

.equ BUFFERSIZE,          100
/*******************************************/
/* Initialized data                        */
/*******************************************/
.data
szMessString:            .asciz "String :\n"
szString1:              .asciz "Alphabet : "
sComplement:            .fill BUFFERSIZE,1,0
szString2:              .asciz "abcdefghijklmnopqrstuvwxyz"

szCarriageReturn:       .asciz "\n"
/*******************************************/
/* UnInitialized data                      */
/*******************************************/
.bss
/*******************************************/
/*  code section                           */
/*******************************************/
.text
.global main
main:

    ldr x0,qAdrszMessString               // display message
    bl affichageMess
    ldr x0,qAdrszString1                  // display begin string
    bl affichageMess
    ldr x0,qAdrszCarriageReturn           // display return line
    bl affichageMess
    ldr x0,qAdrszString1
    ldr x1,qAdrszString2
    bl append                             // append sting2 to string1
    ldr x0,qAdrszMessString
    bl affichageMess
    ldr x0,qAdrszString1                  // display string
    bl affichageMess
    ldr x0,qAdrszCarriageReturn
    bl affichageMess

100:                                      // standard end of the program
    mov x0,0                              // return code
    mov x8,EXIT                           // request to exit program
    svc 0                                 // perform system call
qAdrszMessString:         .quad szMessString
qAdrszString1:            .quad szString1
qAdrszString2:            .quad szString2
qAdrszCarriageReturn:     .quad szCarriageReturn
/**************************************************/
/*     append two strings                         */
/**************************************************/
/* x0 contains the address of the string1 */
/* x1 contains the address of the string2 */
append:
    stp x1,lr,[sp,-16]!            // save  registers
    mov x2,#0                      // counter byte string 1
1:
    ldrb w3,[x0,x2]                // load byte string 1
    cmp x3,#0                      // zero final ?
    add x4,x2,1
    csel x2,x4,x2,ne               // if x3 not equal 0, x2 = X2 +1 else x2
    bne 1b                         // no -> loop
    mov x4,#0                      // counter byte string 2
2:
    ldrb w3,[x1,x4]                // load byte string 2
    strb w3,[x0,x2]                // store byte string 1
    cbz x3,100f                    // zero final ?
    add x2,x2,1                    // no -> increment counter 1
    add x4,x4,1                    // no -> increment counter 2
    b 2b                           // no -> loop
100:

    ldp x1,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30
/********************************************************/
/*        File Include fonctions                        */
/********************************************************/
/* for this file see task include a file in language AArch64 assembly */
.include "../includeARM64.inc"
