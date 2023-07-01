/* ARM assembly AARCH64 Raspberry PI 3B */
/*  program heapSort64.s   */
/* look Pseudocode begin this task  */

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
szCarriageReturn:  .asciz "\n"

.align 4
//TableNumber:         .quad   1,3,6,2,5,9,10,8,4,7
TableNumber:         .quad   10,9,8,7,6,-5,4,3,2,1
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
main:                                           // entry of program

1:
    ldr x0,qAdrTableNumber                      // address number table
    mov x1,#NBELEMENTS                          // number of élements
    bl heapSort
    ldr x0,qAdrTableNumber                      // address number table
    bl displayTable

    ldr x0,qAdrTableNumber                      // address number table
    mov x1,#NBELEMENTS                          // number of élements
    bl isSorted                                 // control sort
    cmp x0,#1                                   // sorted ?
    beq 2f
    ldr x0,qAdrszMessSortNok                    // no !! error sort
    bl affichageMess
    b 100f
2:                                              // yes
    ldr x0,qAdrszMessSortOk
    bl affichageMess
100:                                            // standard end of the program
    mov x0, #0                                  // return code
    mov x8, #EXIT                               // request to exit program
    svc #0                                      // perform the system call

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
    stp x2,lr,[sp,-16]!              // save  registers
    stp x3,x4,[sp,-16]!              // save  registers
    mov x2,#0
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
    mov x0,0                      // not sorted
    b 100f
99:
    mov x0,1                      // sorted
100:
    ldp x3,x4,[sp],16              // restaur  2 registers
    ldp x2,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30
/******************************************************************/
/*         heap sort                                              */
/******************************************************************/
/* x0 contains the address of table */
/* x1 contains the number of element */
heapSort:
    stp x1,lr,[sp,-16]!            // save  registers
    stp x2,x3,[sp,-16]!            // save  registers
    bl heapify                     // first place table in max-heap order
    sub x3,x1,1
1:
    cmp x3,0
    ble 100f
    mov x1,0                       // swap the root(maximum value) of the heap with the last element of the heap)
    mov x2,x3
    bl swapElement
    sub x3,x3,1
    mov x1,0
    mov x2,x3                      // put the heap back in max-heap order
    bl siftDown
    b 1b

100:
    ldp x2,x3,[sp],16              // restaur  2 registers
    ldp x1,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30
/******************************************************************/
/*      place table in max-heap order                             */
/******************************************************************/
/* x0 contains the address of table */
/* x1 contains the number of element */
heapify:
    stp x1,lr,[sp,-16]!            // save  registers
    stp x2,x3,[sp,-16]!            // save  registers
    str x4,[sp,-16]!               // save  registers
    mov x4,x1
    sub x3,x1,2
    lsr x3,x3,1
1:
    cmp x3,0
    blt 100f
    mov x1,x3
    sub x2,x4,1
    bl siftDown
    sub x3,x3,1
    b 1b
100:
    ldr x4,[sp],16                 // restaur  1 registers
    ldp x2,x3,[sp],16              // restaur  2 registers
    ldp x1,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30
/******************************************************************/
/*     swap two elements of table                                  */
/******************************************************************/
/* x0 contains the address of table */
/* x1 contains the first index */
/* x2 contains the second index */
swapElement:
    stp x2,lr,[sp,-16]!            // save  registers
    stp x3,x4,[sp,-16]!            // save  registers
    ldr x3,[x0,x1,lsl #3]          // swap number on the table
    ldr x4,[x0,x2,lsl #3]
    str x4,[x0,x1,lsl #3]
    str x3,[x0,x2,lsl #3]
100:
    ldp x3,x4,[sp],16              // restaur  2 registers
    ldp x2,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30

/******************************************************************/
/*     put the heap back in max-heap order                        */
/******************************************************************/
/* x0 contains the address of table */
/* x1 contains the first index */
/* x2 contains the last index */
siftDown:
    stp x1,lr,[sp,-16]!            // save  registers
    stp x2,x3,[sp,-16]!            // save  registers
    stp x4,x5,[sp,-16]!            // save  registers
    stp x6,x7,[sp,-16]!            // save  registers
                                   // x1 = root = start
    mov x3,x2                      // save last index
1:
    lsl x4,x1,1
    add x4,x4,1
    cmp x4,x3
    bgt 100f
    add x5,x4,1
    cmp x5,x3
    bgt 2f
    ldr x6,[x0,x4,lsl 3]           // compare elements on the table
    ldr x7,[x0,x5,lsl 3]
    cmp x6,x7
    csel x4,x5,x4,lt
    //movlt x4,x5
2:
    ldr x7,[x0,x4,lsl 3]           // compare elements on the table
    ldr x6,[x0,x1,lsl 3]           // root
    cmp x6,x7
    bge 100f
    mov x2,x4                      // and x1 is root
    bl swapElement
    mov x1,x4                      // root = child
    b 1b

100:
    ldp x6,x7,[sp],16              // restaur  2 registers
    ldp x4,x5,[sp],16              // restaur  2 registers
    ldp x2,x3,[sp],16              // restaur  2 registers
    ldp x1,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30

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
    bl strInsertAtCharInc            // insert result at @ character
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
qAdrsZoneConv:            .quad sZoneConv
/********************************************************/
/*        File Include fonctions                        */
/********************************************************/
/* for this file see task include a file in language AArch64 assembly */
.include "../includeARM64.inc"
