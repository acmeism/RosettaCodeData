/* ARM assembly AARCH64 Raspberry PI 3B */
/*  program insertString64.s   */
/* In assembler, there is no function to insert a chain */
/* so this program offers two functions to insert    */
/*******************************************/
/* Constantes file                         */
/*******************************************/
/* for this file see task include a file in language AArch64 assembly*/
.include "../includeConstantesARM64.inc"

.equ CHARPOS,       '@'

/*******************************************/
/* Initialized data                        */
/*******************************************/
.data
szString:           .asciz " string "
szString1:          .asciz "insert"
szString2:          .asciz "abcd@efg"
szString3:          .asciz "abcdef @"
szString4:          .asciz "@ abcdef"
szCarriageReturn:   .asciz "\n"
/*******************************************/
/* UnInitialized data                      */
/*******************************************/
.bss
/*******************************************/
/*  code section                           */
/*******************************************/
.text
.global main
main:                            // entry of program

    ldr x0,qAdrszString          // string address
    ldr x1,qAdrszString1         // string address
    mov x2,#0
    bl strInsert                 //
                                 // return new pointer
    bl affichageMess             // display result string
    ldr x0,qAdrszCarriageReturn
    bl affichageMess

    ldr x0,qAdrszString          // string address
    ldr x1,qAdrszString1         // string address
    mov x2,#3
    bl strInsert                 //
                                 // return new pointer
    bl affichageMess             // display result string
    ldr x0,qAdrszCarriageReturn
    bl affichageMess

    ldr x0,qAdrszString          // string address
    ldr x1,qAdrszString1         // string address
    mov x2,#40
    bl strInsert                 //
                                 // return new pointer
    bl affichageMess             // display result string
    ldr x0,qAdrszCarriageReturn
    bl affichageMess

    ldr x0,qAdrszString2         // string address
    ldr x1,qAdrszString1         // string address
    bl strInsertAtChar           //
                                 // return new pointer
    bl affichageMess             // display result string
    ldr x0,qAdrszCarriageReturn
    bl affichageMess

    ldr x0,qAdrszString3         // string address
    ldr x1,qAdrszString1         // string address
    bl strInsertAtChar           //
                                 // return new pointer
    bl affichageMess             // display result string
    ldr x0,qAdrszCarriageReturn
    bl affichageMess

    ldr x0,qAdrszString4         // string address
    ldr x1,qAdrszString1         // string address
    bl strInsertAtChar           //
                                 // return new pointer
    bl affichageMess             // display result string
    ldr x0,qAdrszCarriageReturn
    bl affichageMess
100:                             // standard end of the program
    mov x0, #0                   // return code
    mov x8, #EXIT                // request to exit program
    svc 0                        // perform the system call
qAdrszString:          .quad szString
qAdrszString1:         .quad szString1
qAdrszString2:         .quad szString2
qAdrszString3:         .quad szString3
qAdrszString4:         .quad szString4
qAdrszCarriageReturn:  .quad szCarriageReturn
/******************************************************************/
/*   insertion of a sub-chain in a chain in the desired position  */
/******************************************************************/
/* x0 contains the address of string 1 */
/* x1 contains the address of string to insert */
/* x2 contains the position of insertion :
      0 start string
      if x2 > lenght string 1 insert at end of string*/
/* x0 return the address of new string  on the heap */
strInsert:
    stp x1,lr,[sp,-16]!                      // save  registers
    stp x2,x3,[sp,-16]!                      // save  registers
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
    //
    mov x8,#0                                // index load characters string 1
    cmp x2,#0                                // index insertion = 0
    beq 5f                                   // insertion at string 1 begin
3:                                           // loop copy characters string 1
    ldrb w0,[x6,x8]                          // load character
    cmp w0,#0                                // end string ?
    beq 5f                                   // insertion at end
    strb w0,[x5,x8]                          // store character in output string
    add x8,x8,#1                             // increment index
    cmp x8,x2                                // < insertion index ?
    blt 3b                                   // yes -> loop
5:
    mov x4,x8                                // init index character output string
    mov x3,#0                                // index load characters insertion string
6:
    ldrb w0,[x1,x3]                          // load characters insertion string
    cmp w0,#0                                // end string ?
    beq 7f
    strb w0,[x5,x4]                          // store in output string
    add x3,x3,#1                             // increment index
    add x4,x4,#1                             // increment output index
    b 6b                                     // and loop
7:
    ldrb w0,[x6,x8]                          // load other character string 1
    strb w0,[x5,x4]                          // store in output string
    cmp x0,#0                                // end string 1 ?
    beq 8f                                   // yes -> end
    add x4,x4,#1                             // increment output index
    add x8,x8,#1                             // increment index
    b 7b                                     // and loop
8:
    mov x0,x5                                // return output string address
    b 100f
99:                                          // error
    mov x0,#-1
100:
    ldp x2,x3,[sp],16                        // restaur  2 registers
    ldp x1,lr,[sp],16                        // restaur  2 registers
    ret
/******************************************************************/
/*   insert string at character insertion                         */
/******************************************************************/
/* x0 contains the address of string 1 */
/* x1 contains the address of insertion string   */
/* x0 return the address of new string  on the heap */
/* or -1 if error   */
strInsertAtChar:
    stp x1,lr,[sp,-16]!                      // save  registers
    stp x2,x3,[sp,-16]!                      // save  registers
    mov x3,#0                                // length counter
1:                                           // compute length of string 1
    ldrb w4,[x0,x3]
    cmp w4,#0
    cinc  x3,x3,ne                           // increment to one if not equal
    bne 1b                                   // loop if not equal
    mov x5,#0                                // length counter insertion string
2:                                           // compute length to insertion string
    ldrb w4,[x1,x5]
    cmp x4,#0
    cinc  x5,x5,ne                           // increment to one if not equal
    bne 2b                                   // and loop
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

    mov x2,0
    mov x4,0
3:                                           // loop copy string begin
    ldrb w3,[x6,x2]
    cmp w3,0
    beq 99f
    cmp w3,CHARPOS                           // insertion character ?
    beq 5f                                   // yes
    strb w3,[x5,x4]                          // no store character in output string
    add x2,x2,1
    add x4,x4,1
    b 3b                                     // and loop
5:                                           // x4 contains position insertion
    add x8,x4,1                              // init index character output string
                                             // at position insertion + one
    mov x3,#0                                // index load characters insertion string
6:
    ldrb w0,[x1,x3]                          // load characters insertion string
    cmp w0,#0                                // end string ?
    beq 7f                                   // yes
    strb w0,[x5,x4]                          // store in output string
    add x3,x3,#1                             // increment index
    add x4,x4,#1                             // increment output index
    b 6b                                     // and loop
7:                                           // loop copy end string
    ldrb w0,[x6,x8]                          // load other character string 1
    strb w0,[x5,x4]                          // store in output string
    cmp x0,#0                                // end string 1 ?
    beq 8f                                   // yes -> end
    add x4,x4,#1                             // increment output index
    add x8,x8,#1                             // increment index
    b 7b                                     // and loop
8:
    mov x0,x5                                // return output string address
    b 100f
99:                                          // error
    mov x0,#-1
100:
    ldp x2,x3,[sp],16                        // restaur  2 registers
    ldp x1,lr,[sp],16                        // restaur  2 registers
    ret

/********************************************************/
/*        File Include fonctions                        */
/********************************************************/
/* for this file see task include a file in language AArch64 assembly */
.include "../includeARM64.inc"
