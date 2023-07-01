/* ARM assembly AARCH64 Raspberry PI 3B */
/*  program cocktailSort64.s  */

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
#TableNumber:      .quad   1,3,6,2,5,9,10,8,4,7
TableNumber:     .quad   10,9,8,7,6,-5,4,3,2,1
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
    mov x1,0
    mov x2,NBELEMENTS                              // number of élements
    bl cocktailSort
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
    stp x2,lr,[sp,-16]!              // save  registers
    stp x3,x4,[sp,-16]!              // save  registers
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
/*         cocktail sort                                              */
/******************************************************************/
/* x0 contains the address of table */
/* x1 contains the first element    */
/* x2 contains the number of element */
cocktailSort:
    stp x1,lr,[sp,-16]!        // save  registers
    stp x2,x3,[sp,-16]!        // save  registers
    stp x4,x5,[sp,-16]!        // save  registers
    stp x6,x7,[sp,-16]!        // save  registers
    stp x8,x9,[sp,-16]!        // save  registers
    sub x2,x2,1                // compute i = n - 1
1:                             // start loop 1
    mov x3,x1                  // start index
    mov x9,0
    sub x7,x2,1
2:                             // start loop 2
    add x4,x3,1
    ldr x5,[x0,x3,lsl 3]       // load value A[j]
    ldr x6,[x0,x4,lsl 3]       // load value A[j+1]
    cmp x6,x5                  // compare value
    bge 3f
    str x6,[x0,x3,lsl 3]       // if smaller inversion
    str x5,[x0,x4,lsl 3]
    mov x9,1                   // top table not sorted
3:
    add x3,x3,1                // increment index j
    cmp x3,x7                  // end ?
    ble 2b                     // no -> loop 2
    cmp x9,0                   // table sorted ?
    beq 100f                   // yes -> end
    mov x9,0
    mov x3,x7
4:
    add x4,x3,1
    ldr x5,[x0,x3,lsl 3]       // load value A[j]
    ldr x6,[x0,x4,lsl 3]       // load value A[j+1]
    cmp x6,x5                  // compare value
    bge 5f
    str x6,[x0,x3,lsl 3]       // if smaller inversion
    str x5,[x0,x4,lsl 3]
    mov x9,1                   // top table not sorted
5:
    sub x3,x3,1                // decrement index j
    cmp x3,x1                  // end ?
    bge 4b                     // no -> loop 2

    cmp x9,0                   // table sorted ?
    bne 1b                     // no -> loop 1

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
100:
    ldp x2,x3,[sp],16               // restaur  2 registers
    ldp x1,lr,[sp],16               // restaur  2 registers
    ret                             // return to address lr x30
/********************************************************/
/*        File Include fonctions                        */
/********************************************************/
/* for this file see task include a file in language AArch64 assembly */
.include "../includeARM64.inc"
