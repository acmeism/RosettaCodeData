/* ARM assembly AARCH64 Raspberry PI 3B */
/*  program subString64.s   */

/*******************************************/
/* Constantes file                         */
/*******************************************/
/* for this file see task include a file in language AArch64 assembly*/
.include "../includeConstantesARM64.inc"

/*******************************************/
/* Initialized data                        */
/*******************************************/
.data
szMessString:            .asciz "Result : "
szString1:               .asciz "abcdefghijklmnopqrstuvwxyz"
szStringStart:           .asciz "abcdefg"
szCarriageReturn:        .asciz "\n"
/*******************************************/
/* UnInitialized data                      */
/*******************************************/
.bss
szSubString:             .skip 500             // buffer result

/*******************************************/
/*  code section                           */
/*******************************************/
.text
.global main
main:

    ldr x0,qAdrszString1                        // address input string
    ldr x1,qAdrszSubString                      // address output string
    mov x2,22                                   // location
    mov x3,4                                    // length
    bl subStringNbChar                          // starting from n characters in and of m length
    ldr x0,qAdrszMessString                     // display message
    bl affichageMess
    ldr x0,qAdrszSubString                      // display substring result
    bl affichageMess
    ldr x0,qAdrszCarriageReturn                 // display line return
    bl affichageMess
    //
    ldr x0,qAdrszString1
    ldr x1,qAdrszSubString
    mov x2,15                                   // location
    bl subStringEnd                             //starting from n characters in, up to the end of the string
    ldr x0,qAdrszMessString                     // display message
    bl affichageMess
    ldr x0,qAdrszSubString
    bl affichageMess
    ldr x0,qAdrszCarriageReturn                 // display line return
    bl affichageMess
    //
    ldr x0,qAdrszString1
    ldr x1,qAdrszSubString
    bl subStringMinus                           // whole string minus last character
    ldr x0,qAdrszMessString                     // display message
    bl affichageMess
    ldr x0,qAdrszSubString
    bl affichageMess
    ldr x0,qAdrszCarriageReturn                 // display line return
    bl affichageMess
    //
    ldr x0,qAdrszString1
    ldr x1,qAdrszSubString
    mov x2,'c'                                  // start character
    mov x3,5                                    // length
    bl subStringStChar                          //starting from a known character within the string and of m length
    cmp x0,-1                                   // error ?
    beq 2f
    ldr x0,qAdrszMessString                     // display message
    bl affichageMess
    ldr x0,qAdrszSubString
    bl affichageMess
    ldr x0,qAdrszCarriageReturn                 // display line return
    bl affichageMess
    //
2:
    ldr x0,qAdrszString1
    ldr x1,qAdrszSubString
    ldr x2,qAdrszStringStart                    // sub string to start
    mov x3,10                                   // length
    bl subStringStString                        // starting from a known substring within the string and of m length
    cmp x0,-1                                   // error ?
    beq 3f
    ldr x0,qAdrszMessString                     // display message
    bl affichageMess
    ldr x0,qAdrszSubString
    bl affichageMess
    ldr x0,qAdrszCarriageReturn                 // display line return
    bl affichageMess
3:
100:                                            // standard end of the program
    mov x0,0                                    // return code
    mov x8,EXIT                                 // request to exit program
    svc 0                                       // perform system call
qAdrszMessString:         .quad szMessString
qAdrszString1:            .quad szString1
qAdrszSubString:          .quad szSubString
qAdrszStringStart:        .quad szStringStart
qAdrszCarriageReturn:     .quad szCarriageReturn
/******************************************************************/
/*     sub strings  index start  number of characters             */
/******************************************************************/
/* x0 contains the address of the input string */
/* x1 contains the address of the output string */
/* x2 contains the start index                  */
/* x3 contains numbers of characters to extract */
/* x0 returns number of characters or -1 if error */
subStringNbChar:
    stp x1,lr,[sp,-16]!            // save  registers
    mov x14,#0                     // counter byte output string
1:
    ldrb w15,[x0,x2]               // load byte string input
    cbz x15,2f                     // zero final ?
    strb w15,[x1,x14]              // store byte output string
    add x2,x2,1                    // increment counter
    add x14,x14,1
    cmp x14,x3                     // end ?
    blt 1b                         // no -> loop
2:
    strb wzr,[x1,x14]              // store final zero byte string 2
    mov x0,x14
100:
    ldp x1,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30
/******************************************************************/
/*     sub strings  index start at end of string             */
/******************************************************************/
/* x0 contains the address of the input string */
/* x1 contains the address of the output string */
/* x2 contains the start index                  */
/* x0 returns number of characters or -1 if error */
subStringEnd:
    stp x2,lr,[sp,-16]!            // save  registers
    mov x14,0                      // counter byte output string
1:
    ldrb w15,[x0,x2]               // load byte string 1
    cbz x15,2f                     // zero final ?
    strb w15,[x1,x14]
    add x2,x2,1
    add x14,x14,1
    b 1b                           // loop
2:
    strb wzr,[x1,x14]              // store final zero byte string 2
    mov x0,x14
100:

    ldp x2,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30
/******************************************************************/
/*      whole string minus last character                        */
/******************************************************************/
/* x0 contains the address of the input string */
/* x1 contains the address of the output string */
/* x0 returns number of characters or -1 if error */
subStringMinus:
    stp x1,lr,[sp,-16]!            // save  registers
    mov x12,0                      // counter byte input string
    mov x14,0                      // counter byte output string
1:
    ldrb w15,[x0,x12]              // load byte string
    cbz x15,2f                     // zero final ?
    strb w15,[x1,x14]
    add x12,x12,1
    add x14,x14,1
    b 1b                           //  loop
2:
    sub x14,x14,1
    strb wzr,[x1,x14]              // store final zero byte string 2
    mov x0,x14
100:
    ldp x1,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30
/******************************************************************/
/*   starting from a known character within the string and of m length  */
/******************************************************************/
/* x0 contains the address of the input string */
/* x1 contains the address of the output string */
/* x2 contains the character    */
/* x3 contains the length
/* x0 returns number of characters or -1 if error */
subStringStChar:
    stp x1,lr,[sp,-16]!            // save  registers
    mov x16,0                      // counter byte input string
    mov x14,0                      // counter byte output string
1:
    ldrb w15,[x0,x16]              // load byte string
    cbz x15,4f                     // zero final ?
    cmp x15,x2                     // character find ?
    beq 2f                         // yes
    add x16,x16,1                  // no -> increment indice
    b 1b                           //  loop
2:
    strb w15,[x1,x14]
    add x16,x16,1
    add x14,x14,1
    cmp x14,x3
    bge 3f
    ldrb w15,[x0,x16]              // load byte string
    cbnz x15,2b                    // loop if no zero final
3:
    strb wzr,[x1,x14]              // store final zero byte string 2
    mov x0,x14
    b 100f
4:
    strb w15,[x1,x14]
    mov x0,#-1
100:
    ldp x1,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30
/******************************************************************/
/*   starting from a known substring within the string and of m length  */
/******************************************************************/
/* x0 contains the address of the input string */
/* x1 contains the address of the output string */
/* x2 contains the address of string to start    */
/* x3 contains the length
/* x0 returns number of characters or -1 if error */
subStringStString:
    stp x1,lr,[sp,-16]!            // save  registers
    stp x20,x21,[sp,-16]!          // save  registers
    mov x20,x0                     // save address
    mov x21,x1                     // save address output string
    mov x1,x2
    bl searchSubString
    cmp x0,-1                      // not found ?
    beq 100f
    mov x16,x0                     // counter byte input string
    mov x14,0
1:
    ldrb w15,[x20,x16]             // load byte string
    strb w15,[x21,x14]
    cmp x15,#0                     // zero final ?
    csel x0,x14,x0,eq
    beq 100f
    add x14,x14,1
    cmp x14,x3
    add x15,x16,1
    csel x16,x15,x16,lt
    blt 1b                         //  loop
    strb wzr,[x21,x14]
    mov x0,x14                     // return indice
100:
    ldp x20,x21,[sp],16              // restaur  2 registers
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
    mov x12,0                      // counter byte input string
    mov x13,0                      // counter byte string
    mov x16,-1                     // index found
    ldrb w14,[x1,x13]
1:
    ldrb w15,[x0,x12]              // load byte string
    cbz x15,4f                     // zero final ?
    cmp x15,x14                    // compare character
    beq 2f
    mov x16,-1                     // no equals - > raz index
    mov x13,0                      // and raz counter byte
    add x12,x12,1                  // and increment counter byte
    b 1b                           // and loop
2:                                 // characters equals
    cmp x16,-1                     // first characters equals ?
    csel x16,x12,x16,eq
   // moveq x6,x2                  // yes -> index begin in x6
    add x13,x13,1                  // increment counter substring
    ldrb w14,[x1,x13]              // and load next byte
    cbz x14,3f                     // zero final ? yes -> end search
    add x12,x12,1                  // else increment counter string
    b 1b                           // and loop
3:
    mov x0,x16                     // return indice
    b 100f
4:
   mov x0,#-1                      // yes returns error
100:
    ldp x1,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30
/********************************************************/
/*        File Include fonctions                        */
/********************************************************/
/* for this file see task include a file in language AArch64 assembly */
.include "../includeARM64.inc"
