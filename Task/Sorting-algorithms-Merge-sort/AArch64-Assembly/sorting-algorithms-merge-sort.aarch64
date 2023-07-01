/* ARM assembly AARCH64 Raspberry PI 3B */
/*  program mergeSort64.s  */

/*******************************************/
/* Constantes file                         */
/*******************************************/
/* for this file see task include a file in language AArch64 assembly */
.include "../includeConstantesARM64.inc"

/*********************************/
/* Initialized data              */
/*********************************/
.data
szMessSortOk:       .asciz "Table sorted.\n"
szMessSortNok:      .asciz "Table not sorted !!!!!.\n"
sMessResult:        .asciz "Value  : @ \n"
szCarriageReturn:   .asciz "\n"

.align 4
TableNumber:      .quad   1,3,11,6,2,5,9,10,8,4,7
#TableNumber:     .quad   10,9,8,7,6,-5,4,3,2,1
                 .equ NBELEMENTS, (. - TableNumber) / 8
/*********************************/
/* UnInitialized data            */
/*********************************/
.bss
sZoneConv:       .skip 24
/*********************************/
/*  code section                 */
/*********************************/
.text
.global main
main:                                              // entry of program
    ldr x0,qAdrTableNumber                         // address number table
    mov x1,0                                       // first element
    mov x2,NBELEMENTS                              // number of élements
    bl mergeSort
    ldr x0,qAdrTableNumber                         // address number table
    bl displayTable

    ldr x0,qAdrTableNumber                         // address number table
    mov x1,NBELEMENTS                              // number of élements
    bl isSorted                                    // control sort
    cmp x0,1                                       // sorted ?
    beq 1f
    ldr x0,qAdrszMessSortNok                       // no !! error sort
    bl affichageMess
    b 100f
1:                                                 // yes
    ldr x0,qAdrszMessSortOk
    bl affichageMess
100:                                               // standard end of the program
    mov x0,0                                       // return code
    mov x8,EXIT                                    // request to exit program
    svc 0                                          // perform the system call

qAdrsZoneConv:            .quad sZoneConv
qAdrszCarriageReturn:     .quad szCarriageReturn
qAdrsMessResult:          .quad sMessResult
qAdrTableNumber:          .quad TableNumber
qAdrszMessSortOk:         .quad szMessSortOk
qAdrszMessSortNok:        .quad szMessSortNok
/******************************************************************/
/*     control sorted table                                   */
/******************************************************************/
/* x0 contains the address of table */
/* x1 contains the number of elements  > 0  */
/* x0 return 0  if not sorted   1  if sorted */
isSorted:
    stp x2,lr,[sp,-16]!             // save  registers
    stp x3,x4,[sp,-16]!             // save  registers
    mov x2,0
    ldr x4,[x0,x2,lsl 3]
1:
    add x2,x2,1
    cmp x2,x1
    bge 99f
    ldr x3,[x0,x2, lsl 3]
    cmp x3,x4
    blt 98f
    mov x4,x3
    b 1b
98:
    mov x0,0                       // not sorted
    b 100f
99:
    mov x0,1                       // sorted
100:
    ldp x3,x4,[sp],16              // restaur  2 registers
    ldp x2,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30
/******************************************************************/
/*         merge                                              */
/******************************************************************/
/* r0 contains the address of table */
/* r1 contains first start index
/* r2 contains second start index */
/* r3 contains the last index   */
merge:
    stp x1,lr,[sp,-16]!        // save  registers
    stp x2,x3,[sp,-16]!        // save  registers
    stp x4,x5,[sp,-16]!        // save  registers
    stp x6,x7,[sp,-16]!        // save  registers
    str x8,[sp,-16]!
    mov x5,x2                  // init index x2->x5
1:                             // begin loop first section
    ldr x6,[x0,x1,lsl 3]       // load value first section index r1
    ldr x7,[x0,x5,lsl 3]       // load value second section index r5
    cmp x6,x7
    ble 4f                     // <=  -> location first section OK
    str x7,[x0,x1,lsl 3]       // store value second section in first section
    add x8,x5,1
    cmp x8,x3                  // end second section ?
    ble 2f
    str x6,[x0,x5,lsl 3]
    b 4f                       // loop
2:                             // loop insert element part 1 into part 2
    sub x4,x8,1
    ldr x7,[x0,x8,lsl 3]       // load value 2
    cmp x6,x7                  // value <
    bge 3f
    str x6,[x0,x4,lsl 3]       // store value
    b 4f                       // loop
3:
    str x7,[x0,x4,lsl 3]       // store value 2
    add x8,x8,1
    cmp x8,x3                  // end second section ?
    ble 2b                     // no loop
    sub x8,x8,1
    str x6,[x0,x8,lsl 3]       // store value 1
4:
    add x1,x1,1
    cmp x1,x2                  // end first section ?
    blt 1b

100:
    ldr x8,[sp],16             // restaur 1 register
    ldp x6,x7,[sp],16          // restaur  2 registers
    ldp x4,x5,[sp],16          // restaur  2 registers
    ldp x2,x3,[sp],16          // restaur  2 registers
    ldp x1,lr,[sp],16          // restaur  2 registers
    ret                        // return to address lr x30
/******************************************************************/
/*      merge sort                                                */
/******************************************************************/
/* x0 contains the address of table */
/* x1 contains the index of first element */
/* x2 contains the number of element */
mergeSort:
    stp x3,lr,[sp,-16]!    // save  registers
    stp x4,x5,[sp,-16]!    // save  registers
    stp x6,x7,[sp,-16]!    // save  registers
    cmp x2,2               // end ?
    blt 100f
    lsr x4,x2,1            // number of element of each subset
    add x5,x4,1
    tst x2,#1              // odd ?
    csel x4,x5,x4,ne
    mov x5,x1              // save first element
    mov x6,x2              // save number of element
    mov x7,x4              // save number of element of each subset
    mov x2,x4
    bl mergeSort
    mov x1,x7              // restaur number of element of each subset
    mov x2,x6              // restaur  number of element
    sub x2,x2,x1
    mov x3,x5              // restaur first element
    add x1,x1,x3              // + 1
    bl mergeSort           // sort first subset
    mov x1,x5              // restaur first element
    mov x2,x7              // restaur number of element of each subset
    add x2,x2,x1
    mov x3,x6              // restaur  number of element
    add x3,x3,x1
    sub x3,x3,1              // last index
    bl merge
100:
    ldp x6,x7,[sp],16          // restaur  2 registers
    ldp x4,x5,[sp],16          // restaur  2 registers
    ldp x3,lr,[sp],16          // restaur  2 registers
    ret                        // return to address lr x30

/******************************************************************/
/*      Display table elements                                */
/******************************************************************/
/* x0 contains the address of table */
displayTable:
    stp x1,lr,[sp,-16]!              // save  registers
    stp x2,x3,[sp,-16]!              // save  registers
    mov x2,x0                        // table address
    mov x3,0
1:                                   // loop display table
    ldr x0,[x2,x3,lsl 3]
    ldr x1,qAdrsZoneConv
    bl conversion10S                  // décimal conversion
    ldr x0,qAdrsMessResult
    ldr x1,qAdrsZoneConv
    bl strInsertAtCharInc            // insert result at // character
    bl affichageMess                 // display message
    add x3,x3,1
    cmp x3,NBELEMENTS - 1
    ble 1b
    ldr x0,qAdrszCarriageReturn
    bl affichageMess
    mov x0,x2
100:
    ldp x2,x3,[sp],16               // restaur  2 registers
    ldp x1,lr,[sp],16               // restaur  2 registers
    ret                             // return to address lr x30
/********************************************************/
/*        File Include fonctions                        */
/********************************************************/
/* for this file see task include a file in language AArch64 assembly */
.include "../includeARM64.inc"
