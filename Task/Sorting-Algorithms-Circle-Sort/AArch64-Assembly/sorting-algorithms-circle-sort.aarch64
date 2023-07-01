/* ARM assembly AARCH64 Raspberry PI 3B */
/*  program circleSort64.s  */

/*******************************************/
/* Constantes file                         */
/*******************************************/
/* for this file see task include a file in language AArch64 assembly*/
.include "../includeConstantesARM64.inc"

/*********************************/
/* Initialized data              */
/*********************************/
.data
szMessSortOk:       .asciz "Table sorted.\n"
szMessSortNok:      .asciz "Table not sorted !!!!!.\n"
szMessSortBefore:   .asciz "Display table before sort.\n"
sMessResult:        .asciz "Value  : @ \n"
szCarriageReturn:   .asciz "\n"

.align 4
#TableNumber:      .quad   1,3,6,2,5,9,10,8,4,7
#TableNumber:       .quad   1,2,3,4,5,6,7,8,9,10
#TableNumber:       .quad   9,5,12,8,2,12,6
TableNumber:       .quad   10,9,8,7,6,5,4,3,2,1
                   .equ NBELEMENTS, (. - TableNumber) / 8
/*********************************/
/* UnInitialized data            */
/*********************************/
.bss
sZoneConv:            .skip 24
/*********************************/
/*  code section                 */
/*********************************/
.text
.global main
main:                               // entry of program
    ldr x0,qAdrszMessSortBefore
    bl affichageMess
    ldr x0,qAdrTableNumber          // address number table
    bl displayTable
1:
    ldr x0,qAdrTableNumber          // address number table
    mov x1,#0
    mov x2,#NBELEMENTS -1           // number of élements
    mov x3,#0
    bl circleSort
    cmp x0,#0
    bne 1b
    ldr x0,qAdrTableNumber          // address number table
    mov x1,#NBELEMENTS              // number of élements
    bl displayTable

    ldr x0,qAdrTableNumber          // address number table
    mov x1,#NBELEMENTS              // number of élements
    bl isSorted                     // control sort
    cmp x0,#1                       // sorted ?
    beq 2f
    ldr x0,qAdrszMessSortNok        // no !! error sort
    bl affichageMess
    b 100f
2:                                  // yes
    ldr x0,qAdrszMessSortOk
    bl affichageMess
100:                                // standard end of the program
    mov x0, #0                      // return code
    mov x8, #EXIT                   // request to exit program
    svc #0                          // perform the system call

qAdrszCarriageReturn:     .quad szCarriageReturn
qAdrsMessResult:          .quad sMessResult
qAdrTableNumber:          .quad TableNumber
qAdrszMessSortOk:         .quad szMessSortOk
qAdrszMessSortNok:        .quad szMessSortNok
qAdrszMessSortBefore:     .quad szMessSortBefore
/******************************************************************/
/*     control sorted table                                   */
/******************************************************************/
/* x0 contains the address of table */
/* x1 contains the number of elements  > 0  */
/* x0 return 0  if not sorted   1  if sorted */
isSorted:
    stp x2,lr,[sp,-16]!          // save  registers
    stp x3,x4,[sp,-16]!          // save  registers
    mov x2,#0
    ldr x4,[x0,x2,lsl #3]
1:
    add x2,x2,#1
    cmp x2,x1
    bge 99f
    ldr x3,[x0,x2, lsl #3]
    cmp x3,x4
    blt 98f                      // smaller -> error
    mov x4,x3                    // A[i-1] = A[i]
    b 1b                         // else loop
98:
    mov x0,#0                    // error
    b 100f
99:
    mov x0,#1                    // ok -> return
100:
    ldp x2,x3,[sp],16            // restaur  2 registers
    ldp x1,lr,[sp],16            // restaur  2 registers
    ret                          // return to address lr x30
/******************************************************************/
/*         circle sort                                              */
/******************************************************************/
/* x0 contains the address of table */
/* x1 contains the first index */
/* x2 contains the last index */
/* x3 contains number of swaps */
circleSort:
    stp x1,lr,[sp,-16]!          // save  registers
    stp x2,x3,[sp,-16]!          // save  registers
    stp x4,x5,[sp,-16]!          // save  registers
    stp x6,x7,[sp,-16]!          // save  registers
    stp x8,x9,[sp,-16]!          // save  registers
    stp x10,x11,[sp,-16]!        // save  registers
    cmp x1,x2
    beq 99f
    mov x7,x0                    // save address
    mov x8,x1                    // low
    mov x9,x2                    // high
    sub x4,x2,x1
    lsr x4,x4,#1
    mov x10,x4                   // mid
1:                               // start loop
    cmp x1,x2
    bge 3f
    ldr x5,[x0,x1,lsl #3]
    ldr x6,[x0,x2,lsl #3]
    cmp x5,x6
    ble 2f
    str x6,[x0,x1,lsl #3]        // swap values
    str x5,[x0,x2,lsl #3]
    add x3,x3,#1
2:
    add x1,x1,#1                 // increment lo
    sub x2,x2,#1                 // decrement hi
    b 1b                         // and loop
3:
    cmp x1,x2                    // compare lo hi
    bne 4f                       // not egal
    ldr x5,[x0,x1,lsl #3]
    add x2,x2,#1
    ldr x6,[x0,x2,lsl #3]
    cmp x5,x6
    ble 4f
    str x6,[x0,x1,lsl #3]        //  swap
    str x5,[x0,x2,lsl #3]
    add x3,x3,#1
4:
    mov x1,x8                    // low
    mov x2,x10                   // mid
    add x2,x2,x1
    bl circleSort
    mov x3,x0                    // swaps
    mov x0,x7                    // table address
    mov x1,x8                    // low
    mov x2,x10                   // mid
    add x1,x2,x1
    add x1,x1,#1
    mov x2,x9                    // high
    bl circleSort
    mov x3,x0                    // swaps
99:
    mov x0,x3                    // return number swaps
100:
    ldp x10,x11,[sp],16          // restaur  2 registers
    ldp x8,x9,[sp],16            // restaur  2 registers
    ldp x6,x7,[sp],16            // restaur  2 registers
    ldp x4,x5,[sp],16            // restaur  2 registers
    ldp x2,x3,[sp],16            // restaur  2 registers
    ldp x1,lr,[sp],16            // restaur  2 registers
    ret                          // return to address lr x30
/******************************************************************/
/*      Display table elements                                */
/******************************************************************/
/* x0 contains the address of table */
displayTable:
    stp x1,lr,[sp,-16]!          // save  registers
    stp x2,x3,[sp,-16]!          // save  registers
    mov x2,x0                    // table address
    mov x3,#0
1:                               // loop display table
    ldr x0,[x2,x3,lsl #3]
    ldr x1,qAdrsZoneConv
    bl conversion10              // décimal conversion
    ldr x0,qAdrsMessResult
    ldr x1,qAdrsZoneConv         // insert conversion
    bl strInsertAtCharInc
    bl affichageMess             // display message
    add x3,x3,#1
    cmp x3,#NBELEMENTS - 1
    ble 1b
    ldr x0,qAdrszCarriageReturn
    bl affichageMess
100:
    ldp x2,x3,[sp],16            // restaur  2 registers
    ldp x1,lr,[sp],16            // restaur  2 registers
    ret                          // return to address lr x30
qAdrsZoneConv:           .quad sZoneConv
/********************************************************/
/*        File Include fonctions                        */
/********************************************************/
/* for this file see task include a file in language AArch64 assembly */
.include "../includeARM64.inc"
