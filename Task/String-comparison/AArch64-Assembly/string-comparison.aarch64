/* ARM assembly AARCH64 Raspberry PI 3B */
/*  program comparString64.s   */

/*******************************************/
/* Constantes file                         */
/*******************************************/
/* for this file see task include a file in language AArch64 assembly*/
.include "../includeConstantesARM64.inc"
/*******************************************/
/* Initialized data                        */
/*******************************************/
.data
szMessStringEqu:    .asciz "The strings are equals.\n"
szMessStringNotEqu: .asciz "The strings are not equals.\n"
szCarriageReturn:   .asciz "\n"

szString1:          .asciz "ABCDE"
szString2:          .asciz "ABCDE"
szString3:          .asciz "ABCFG"
szString4:          .asciz "ABC"
szString5:          .asciz "abcde"
/*******************************************/
/* UnInitialized data                       /
/*******************************************/
.bss
/*******************************************/
/*  code section */
/*******************************************/
.text
.global main
main:                         // entry of program

    ldr x0,qAdrszString1
    ldr x1,qAdrszString2
    bl Comparaison

    ldr x0,qAdrszString1
    ldr x1,qAdrszString3
    bl Comparaison

    ldr x0,qAdrszString1
    ldr x1,qAdrszString4
    bl Comparaison
                             // case sensitive comparisons ABCDE et abcde
    ldr x0,qAdrszString1
    ldr x1,qAdrszString5
    bl Comparaison
                             // case insensitive comparisons  ABCDE et abcde
    ldr x0,qAdrszString1
    ldr x1,qAdrszString5
    bl comparStringsInsensitive
    cbnz x0,1f
    ldr x0,qAdrszMessStringEqu
    bl affichageMess
    b 2f
1:
    ldr x0,qAdrszMessStringNotEqu
    bl affichageMess

2:

100:                             // standard end of the program
    mov x0,0                     // return code
    mov x8,EXIT                  // request to exit program
    svc 0                        // perform the system call
qAdrszString1:           .quad szString1
qAdrszString2:           .quad szString2
qAdrszString3:           .quad szString3
qAdrszString4:           .quad szString4
qAdrszString5:           .quad szString5
qAdrszMessStringEqu:     .quad szMessStringEqu
qAdrszMessStringNotEqu:  .quad szMessStringNotEqu
qAdrszCarriageReturn:    .quad  szCarriageReturn
/*********************************************/
/* comparaison                               */
/*********************************************/
/* x0 contains address String 1           */
/* x1 contains address String 2         */
Comparaison:
    stp x1,lr,[sp,-16]!            // save  registers
    bl comparStrings
    cbnz x0,1f
    ldr x0,qAdrszMessStringEqu
    bl affichageMess
    b 2f
1:
    ldr x0,qAdrszMessStringNotEqu
    bl affichageMess

2:
    ldp x1,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30

/************************************/
/* Strings case sensitive comparisons  */
/************************************/
/* x0 et x1 contains the address of strings */
/* return 0 in x0 if equals */
/* return -1 if string x0 < string x1 */
/* return 1  if string x0 > string x1 */
comparStrings:
    stp x1,lr,[sp,-16]!    // save  registers
    stp x2,x3,[sp,-16]!    // save  registers
    stp x4,x5,[sp,-16]!    // save  registers
    mov x2,#0              // counter
1:
    ldrb w3,[x0,x2]        // byte string 1
    ldrb w4,[x1,x2]        // byte string 2
    cmp x3,x4
    blt 2f
    bgt 3f
    cbz x3,4f              // 0 end string
    add x2,x2,1            // else add 1 in counter
    b 1b                   // and loop */
2:
    mov x0,-1              // lower
    b 100f
3:
    mov x0,1               // higher
    b 100f
4:
    mov x0,0               // equal
100:
    ldp x4,x5,[sp],16      // restaur  2 registers
    ldp x2,x3,[sp],16      // restaur  2 registers
    ldp x1,lr,[sp],16      // restaur  2 registers
    ret                    // return to address lr x30
/************************************/
/* Strings case insensitive comparisons    */
/************************************/
/* x0 et x1 contains the address of strings */
/* return 0 in x0 if equals */
/* return -1 if string x0 < string x1 */
/* return 1  if string x0 > string x1 */
comparStringsInsensitive:
    stp x1,lr,[sp,-16]!    // save  registers
    stp x2,x3,[sp,-16]!    // save  registers
    stp x4,x5,[sp,-16]!    // save  registers
    mov x2,#0              // counter

1:
    ldrb w3,[x0,x2]        // byte string 1
    ldrb w4,[x1,x2]        // byte string 2
                           // majuscules --> minuscules  byte 1
    cmp x3,65
    blt 2f
    cmp x3,90
    bgt 2f
    add x3,x3,32
2:                         // majuscules --> minuscules  byte 2
    cmp x4,65
    blt 3f
    cmp x4,90
    bgt 3f
    add x4,x4,32
3:
    cmp x3,x4
    blt 4f
    bgt 5f
    cbz x3,6f              // 0 end string
    add x2,x2,1            // else add 1 in counter
    b 1b                   // and loop
4:
    mov x0,-1              // lower
    b 100f
5:
    mov x0,1               // higher
    b 100f
6:
    mov x0,0               // equal
100:
    ldp x4,x5,[sp],16      // restaur  2 registers
    ldp x2,x3,[sp],16      // restaur  2 registers
    ldp x1,lr,[sp],16      // restaur  2 registers
    ret                    // return to address lr x30
/********************************************************/
/*        File Include fonctions                        */
/********************************************************/
/* for this file see task include a file in language AArch64 assembly */
.include "../includeARM64.inc"
