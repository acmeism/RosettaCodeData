/* ARM assembly AARCH64 Raspberry PI 3B */
/*  program strMatching64.s   */

/*******************************************/
/* Constantes file                         */
/*******************************************/
/* for this file see task include a file in language AArch64 assembly*/
.include "../includeConstantesARM64.inc"
/*******************************************/
/* Initialized data                        */
/*******************************************/
.data
szMessFound:             .asciz "String found. \n"
szMessNotFound:          .asciz "String not found. \n"
szString:                .asciz "abcdefghijklmnopqrstuvwxyz"
szString2:               .asciz "abc"
szStringStart:           .asciz "abcd"
szStringEnd:             .asciz "xyz"
szStringStart2:          .asciz "abcd"
szStringEnd2:            .asciz "xabc"
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

    ldr x0,qAdrszString                  // address input string
    ldr x1,qAdrszStringStart             // address search string

    bl searchStringDeb                   // Determining if the first string starts with second string
    cmp x0,0
    ble 1f
    ldr x0,qAdrszMessFound               // display message
    bl affichageMess
    b 2f
1:
    ldr x0,qAdrszMessNotFound
    bl affichageMess
2:
    ldr x0,qAdrszString                 // address input string
    ldr x1,qAdrszStringEnd              // address search string
    bl searchStringFin                  // Determining if the first string ends with the second string
    cmp x0,0
    ble 3f
    ldr x0,qAdrszMessFound              // display message
    bl affichageMess
    b 4f
3:
    ldr x0,qAdrszMessNotFound
    bl affichageMess
4:
    ldr x0,qAdrszString2               // address input string
    ldr x1,qAdrszStringStart2          // address search string

    bl searchStringDeb                 //
    cmp x0,0
    ble 5f
    ldr x0,qAdrszMessFound             // display message
    bl affichageMess
    b 6f
5:
    ldr x0,qAdrszMessNotFound
    bl affichageMess
6:
    ldr x0,qAdrszString2               // address input string
    ldr x1,qAdrszStringEnd2            // address search string
    bl searchStringFin
    cmp x0,0
    ble 7f
    ldr x0,qAdrszMessFound            // display message
    bl affichageMess
    b 8f
7:
    ldr x0,qAdrszMessNotFound
    bl affichageMess
8:
    ldr x0,qAdrszString               // address input string
    ldr x1,qAdrszStringEnd            // address search string
    bl searchSubString                // Determining if the first string contains the second string at any location
    cmp x0,0
    ble 9f
    ldr x0,qAdrszMessFound            // display message
    bl affichageMess
    b 10f
9:
    ldr x0,qAdrszMessNotFound         // display substring result
    bl affichageMess
10:

100:                                  // standard end of the program
    mov x0,0                          // return code
    mov x8,EXIT                       // request to exit program
    svc 0                             // perform system call
qAdrszMessFound:          .quad szMessFound
qAdrszMessNotFound:       .quad szMessNotFound
qAdrszString:             .quad szString
qAdrszString2:            .quad szString2
qAdrszStringStart:        .quad szStringStart
qAdrszStringEnd:          .quad szStringEnd
qAdrszStringStart2:       .quad szStringStart2
qAdrszStringEnd2:         .quad szStringEnd2
qAdrszCarriageReturn:     .quad szCarriageReturn
/******************************************************************/
/*     search substring at begin of input string                  */
/******************************************************************/
/* x0 contains the address of the input string */
/* x1 contains the address of substring */
/* x0 returns 1 if find or 0 if not or -1 if error */
searchStringDeb:
    stp x1,lr,[sp,-16]!            // save  registers
    stp x2,x3,[sp,-16]!            // save  registers
    mov x3,0                       // counter byte  string
    ldrb w4,[x1,x3]                // load first byte of substring
    cbz x4,99f                     // empty string ?
1:
    ldrb w2,[x0,x3]                // load byte string input
    cbz x2,98f                     // zero final ?
    cmp x4,x2                      // bytes equals ?
    bne 98f                        // no not find
    add x3,x3,1                    // increment counter
    ldrb w4,[x1,x3]                // and load next byte of substring
    cbnz x4,1b                     // zero final ?
    mov x0,1                       // yes is ok
    b 100f
98:
    mov x0,0                       // not find
    b 100f
99:
    mov x0,-1                      // error
100:
    ldp x2,x3,[sp],16              // restaur  2 registers
    ldp x1,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30

/******************************************************************/
/*     search substring at end of input string                    */
/******************************************************************/
/* x0 contains the address of the input string */
/* x1 contains the address of substring */
/* x0 returns 1 if find or 0 if not or -1 if error */
searchStringFin:
    stp x1,lr,[sp,-16]!            // save  registers
    stp x2,x3,[sp,-16]!            // save  registers
    stp x4,x5,[sp,-16]!            // save  registers
    mov x3,0                       // counter byte  string
                                   // search the last character of substring
1:
    ldrb w4,[x1,x3]                // load byte of substring
    cmp x4,#0                      // zero final ?
    add x2,x3,1
    csel x3,x2,x3,ne               // no increment counter
    //addne x3,#1                  // no increment counter
    bne 1b                         // and loop
    cbz x3,99f                     // empty string ?

    sub x3,x3,1                    // index of last byte
    ldrb w4,[x1,x3]                // load last byte of substring
                                   // search the last character of string
    mov x2,0                       // index last character
2:
    ldrb w5,[x0,x2]                // load first byte of substring
    cmp x5,0                       // zero final ?
    add x5,x2,1                    // no -> increment counter
    csel x2,x5,x2,ne
    //addne x2,#1                  // no -> increment counter
    bne 2b                         // and loop
    cbz x2,98f                     // empty input string ?
    sub x2,x2,1                    // index last character
3:
    ldrb w5,[x0,x2]                // load byte string input
    cmp x4,x5                      // bytes equals ?
    bne 98f                        // no -> not found
    subs x3,x3,1                   // decrement counter
    blt 97f                        //  ok found
    subs x2,x2,1                   // decrement counter input string
    blt 98f                        // if zero -> not found
    ldrb w4,[x1,x3]                // load previous byte of substring
    b 3b                           // and loop
97:
    mov x0,1                       // yes is ok
    b 100f
98:
    mov x0,0                       // not found
    b 100f
99:
    mov x0,-1                      // error
100:
    ldp x4,x5,[sp],16              // restaur  2 registers
    ldp x2,x3,[sp],16              // restaur  2 registers
    ldp x1,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30

/******************************************************************/
/*   search a substring in the string                            */
/******************************************************************/
/* x0 contains the address of the input string */
/* x1 contains the address of substring */
/* x0 returns index of substring in string or -1 if not found */
searchSubString:
    stp x1,lr,[sp,-16]!            // save  registers
    stp x2,x3,[sp,-16]!            // save  registers
    stp x4,x5,[sp,-16]!            // save  registers
    mov x2,0                       // counter byte input string
    mov x3,0                       // counter byte string
    mov x6,-1                      // index found
    ldrb w4,[x1,x3]
1:
    ldrb w5,[x0,x2]                // load byte string
    cbz x5,99f                     // zero final ?
    cmp x5,x4                      // compare character
    beq 2f
    mov x6,-1                      // no equals - > raz index
    mov x3,0                       // and raz counter byte
    add x2,x2,1                    // and increment counter byte
    b 1b                           // and loop
2:                                 // characters equals
    cmp x6,-1                      // first characters equals ?
    csel x6,x2,x6,eq               // yes -> index begin in x6
    //moveq x6,x2                  // yes -> index begin in x6
    add x3,x3,1                    // increment counter substring
    ldrb w4,[x1,x3]                // and load next byte
    cmp x4,0                       // zero final ?
    beq 3f                         // yes -> end search
    add x2,x2,1                    // else increment counter string
    b 1b                           // and loop
3:
    mov x0,x6
    b 100f

98:
    mov x0,0                      // not found
    b 100f
99:
    mov x0,-1                     // error
100:
    ldp x4,x5,[sp],16              // restaur  2 registers
    ldp x2,x3,[sp],16              // restaur  2 registers
    ldp x1,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30
/********************************************************/
/*        File Include fonctions                        */
/********************************************************/
/* for this file see task include a file in language AArch64 assembly */
.include "../includeARM64.inc"
