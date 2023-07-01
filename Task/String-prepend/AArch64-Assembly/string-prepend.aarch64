/* ARM assembly AARCH64 Raspberry PI 3B */
/*  program appendstr64.s   */

/*******************************************/
/* Constantes file                         */
/*******************************************/
/* for this file see task include a file in language AArch64 assembly*/
.include "../includeConstantesARM64.inc"

/*******************************************/
/* Initialized data                        */
/*******************************************/
.data
szMessString:            .asciz "British Museum.\n"
szComplement:            .skip 80
szStringStart:           .asciz "The rosetta stone is at "
szCarriageReturn:        .asciz "\n"
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

    ldr x0,qAdrszMessString
    ldr x1,qAdrszStringStart
    bl prepend                             // append sting2 to string1
    ldr x0,qAdrszMessString
    bl affichageMess

    ldr x0,qAdrszCarriageReturn
    bl affichageMess


100:                                      // standard end of the program
    mov x0,0                              // return code
    mov x8,EXIT                           // request to exit program
    svc 0                                 // perform system call
qAdrszMessString:         .quad szMessString
qAdrszStringStart:        .quad szStringStart
qAdrszCarriageReturn:     .quad szCarriageReturn
/**************************************************/
/*     append two strings                         */
/**************************************************/
/* x0 contains the address of the string1 */
/* x1 contains the address of the string2 */
prepend:
    stp x1,lr,[sp,-16]!            // save  registers
    mov x3,#0                                // length counter
1:                                           // compute length of string 1
    ldrb w4,[x0,x3]
    cmp w4,#0
    cinc  x3,x3,ne                           // increment to one if not equal
    bne 1b                                   // loop if not equal
    mov x5,#0                                // length counter insertion string
2:                                           // compute length of insertion string
    ldrb w4,[x1,x5]
    cmp x4,#0
    cinc  x5,x5,ne                           // increment to one if not equal
    bne 2b
    cmp x5,#0
    beq 99f                                  // string empty -> error
    add x3,x3,x5                             // add 2 length
    add x3,x3,#1                             // +1 for final zero
    mov x6,x0                                // save address string 1
    mov x0,#0                                // allocation place heap
    mov x8,BRK                               // call system 'brk'
    svc #0
    mov x5,x0                                // save address heap for output string
    add x0,x0,x3                             // reservation place x3 length
    mov x8,BRK                               // call system 'brk'
    svc #0
    cmp x0,#-1                               // allocation error
    beq 99f
    mov x4,#0                      // counter byte string 2
3:
    ldrb w3,[x1,x4]                // load byte string 2
    cbz x3,4f                      // zero final ?
    strb w3,[x5,x4]                // store byte string 2 in heap
    add x4,x4,1                    // increment counter 1
    b 3b                           // no -> loop
4:
    mov x2,#0                      // counter byte string 1
5:
    ldrb w3,[x6,x2]                // load byte string 1
    strb w3,[x5,x4]                // store byte string in heap
    cbz x3,6f                    // zero final ?
    add x2,x2,1                    // no -> increment counter 1
    add x4,x4,1                    // no -> increment counter 2
    b 5b                           // no -> loop
6:                                 // recopie heap in string 1
    mov x2,#0                      // counter byte string
7:
    ldrb w3,[x5,x2]                // load byte string in heap
    strb w3,[x6,x2]                // store byte string 1
    cbz x3,100f                    // zero final ?
    add x2,x2,1                    // no -> increment counter 1
    b 7b                           // no -> loop
100:

    ldp x1,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30
/********************************************************/
/*        File Include fonctions                        */
/********************************************************/
/* for this file see task include a file in language AArch64 assembly */
.include "../includeARM64.inc"
