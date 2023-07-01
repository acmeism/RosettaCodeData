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
sMessCounter:       .asciz "sorted in  @ flips \n"
szCarriageReturn:   .asciz "\n"

.align 4
TableNumber:      .quad   1,3,11,6,2,-5,9,10,8,4,7
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
    bl pancakeSort
    ldr x0,qAdrTableNumber                         // address number table
    bl displayTable
    mov x0,x10                                     // display counter
    ldr x1,qAdrsZoneConv
    bl conversion10S                               // décimal conversion
    ldr x0,qAdrsMessCounter
    ldr x1,qAdrsZoneConv
    bl strInsertAtCharInc                          // insert result at @ character
    bl affichageMess                               // display message
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
qAdrsMessCounter:         .quad sMessCounter
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
/*         flip                                                   */
/******************************************************************/
/* x0 contains the address of table */
/* x1 contains first start index
/* x2 contains the number of elements  */
/* x3 contains the position of flip   */
flip:
    //push {r1-r6,lr}             // save registers
    stp x1,lr,[sp,-16]!           // save  registers
    stp x2,x3,[sp,-16]!           // save  registers
    stp x4,x5,[sp,-16]!           // save  registers
    str x6,   [sp,-16]!           // save  registers
    add x10,x10,#1                // flips counter
    cmp x3,x2
    sub x4,x2,1
    csel x3,x4,x3,ge               // last index if position >= size
1:
    cmp x1,x3
    bge 100f
    ldr x5,[x0,x1,lsl 3]         // load value first  index
    ldr x6,[x0,x3,lsl 3]         // load value position index
    str x6,[x0,x1,lsl 3]         // inversion
    str x5,[x0,x3,lsl 3]         //
    sub x3,x3,1
    add x1,x1,1
    b 1b
100:
    ldr x6,   [sp],16              // restaur  1 register
    ldp x4,x5,[sp],16              // restaur  2 registers
    ldp x2,x3,[sp],16              // restaur  2 registers
    ldp x1,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30
/******************************************************************/
/*         pancake sort                                                   */
/******************************************************************/
/* x0 contains the address of table */
/* x1 contains first start index
/* x2 contains the number of elements  */
pancakeSort:
    stp x1,lr,[sp,-16]!        // save  registers
    stp x2,x3,[sp,-16]!        // save  registers
    stp x4,x5,[sp,-16]!        // save  registers
    stp x6,x7,[sp,-16]!        // save  registers
    stp x8,x9,[sp,-16]!        // save  registers
    sub x7,x2,1                // last index
1:
    mov x5,x1                  // index
    mov x4,0                   // max
    mov x3,0                   // position
    mov x8,1                   // top sorted
    ldr x9,[x0,x5,lsl 3]       // load value A[i-1]
2:
    ldr x6,[x0,x5,lsl 3]       // load value
    cmp x6,x4                  // compare max
    csel x4,x6,x4,ge           // max = A[i}
    csel x3,x5,x3,ge           // position = index
    cmp x6,x9                  // cmp A[i] A[i-1] sorted ?
    csel x8,xzr,x8,lt          // no
    mov x9,x6                  //  A[i-1] = A[i]
    add x5,x5,1                // increment index
    cmp x5,x7                  // end ?
    ble 2b
    cmp x8,1                   // sorted ?
    beq 100f                   // yes -> end
    cmp x3,x7                  // position ok ?
    beq 4f                     // yes
    cmp x3,0                   // first position ?
    beq 3f
    bl flip                    // flip if not greather in first position
3:
    mov x3,x7                  // and flip the whole stack
    bl flip
4:
    //bl displayTable          // to display an intermediate state
    subs x7,x7,1               // decrement number of pancake
    bge 1b                     // and loop
100:
    ldp x8,x9,[sp],16          // restaur  2 registers
    ldp x6,x7,[sp],16          // restaur  2 registers
    ldp x4,x5,[sp],16          // restaur  2 registers
    ldp x2,x3,[sp],16          // restaur  2 registers
    ldp x1,lr,[sp],16          // restaur  2 registers
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
/********************************************************/
/*        File Include fonctions                        */
/********************************************************/
/* for this file see task include a file in language AArch64 assembly */
.include "../includeARM64.inc"
