/* ARM assembly AARCH64 Raspberry PI 3B */
/*  program quickSort64.s  */

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
TableNumber:      .quad   1,3,6,2,5,9,10,8,4,7,11
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
    bl quickSort
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
/***************************************************/
/*   Appel récursif Tri Rapide quicksort           */
/***************************************************/
/* x0 contains the address of table */
/* x1 contains index of first item  */
/* x2 contains the number of elements  > 0  */
quickSort:
    stp x2,lr,[sp,-16]!             // save  registers
    stp x3,x4,[sp,-16]!             // save  registers
    str x5,   [sp,-16]!             // save  registers
    sub x2,x2,1                     // last item index
    cmp x1,x2                       // first > last ?
    bge 100f                        // yes -> end
    mov x4,x0                       // save x0
    mov x5,x2                       // save x2
    bl partition1                   // cutting into 2 parts
    mov x2,x0                       // index partition
    mov x0,x4                       // table address
    bl quickSort                    // sort lower part
    add x1,x2,1                     // index begin = index partition + 1
    add x2,x5,1                     // number of elements
    bl quickSort                    // sort higter part

 100:                               // end function
    ldr x5,   [sp],16               // restaur  1 register
    ldp x3,x4,[sp],16               // restaur  2 registers
    ldp x2,lr,[sp],16               // restaur  2 registers
    ret                             // return to address lr x30

/******************************************************************/
/*      Partition table elements                                */
/******************************************************************/
/* x0 contains the address of table */
/* x1 contains index of first item  */
/* x2 contains index of last item   */
partition1:
    stp x1,lr,[sp,-16]!             // save  registers
    stp x2,x3,[sp,-16]!             // save  registers
    stp x4,x5,[sp,-16]!             // save  registers
    stp x6,x7,[sp,-16]!             // save  registers
    ldr x3,[x0,x2,lsl 3]            // load value last index
    mov x4,x1                       // init with first index
    mov x5,x1                       // init with first index
1:                                  // begin loop
    ldr x6,[x0,x5,lsl 3]            // load value
    cmp x6,x3                       // compare value
    bge 2f
    ldr x7,[x0,x4,lsl 3]            // if < swap value table
    str x6,[x0,x4,lsl 3]
    str x7,[x0,x5,lsl 3]
    add x4,x4,1                     // and increment index 1
2:
    add x5,x5,1                     // increment index 2
    cmp x5,x2                       // end ?
    blt 1b                          // no loop
    ldr x7,[x0,x4,lsl 3]            // swap value
    str x3,[x0,x4,lsl 3]
    str x7,[x0,x2,lsl 3]
    mov x0,x4                       // return index partition
100:
    ldp x6,x7,[sp],16               // restaur  2 registers
    ldp x4,x5,[sp],16               // restaur  2 registers
    ldp x2,x3,[sp],16               // restaur  2 registers
    ldp x1,lr,[sp],16               // restaur  2 registers
    ret                             // return to address lr x30

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
