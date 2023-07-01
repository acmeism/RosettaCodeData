/* ARM assembly AARCH64 Raspberry PI 3B */
/*  program countSort64.s  */

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
#Caution : number strictly positive and not too big
TableNumber:      .quad   1,3,6,2,5,9,10,8,4,5
//TableNumber:     .quad   10,9,8,7,6,5,4,3,2,1
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
    mov x1,NBELEMENTS                              // number of élements
    bl searchMinMax
    mov x3,NBELEMENTS
    bl countSort
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
/* x0 return table address  r1 return min  r2 return max */
searchMinMax:
    stp x3,lr,[sp,-16]!              // save  registers
    stp x3,x4,[sp,-16]!              // save  registers
    mov x3,x1                        // save size
    mov x1,1<<62                     // min
    mov x2,0                         // max
    mov x4,0                         // index
1:
    ldr x5,[x0,x4,lsl 3]
    cmp x5,x1
    csel x1,x5,x1,lt
    cmp x5,x2
    csel x2,x5,x2,gt
    add x4,x4,1
    cmp x4,x3
    blt 1b
100:
    ldp x4,x5,[sp],16                // restaur  2 registers
    ldp x3,lr,[sp],16                // restaur  2 registers
    ret                              // return to address lr x30
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
/*         count sort                                             */
/******************************************************************/
/* x0 contains the address of table */
/* x1 contains the minimum          */
/* x2 contains the maximum          */
/* x3 contains area size            */
/* caution : the count area is in the stack. if max is very large, risk of error */
countSort:
    stp x1,lr,[sp,-16]!        // save  registers
    stp x2,x3,[sp,-16]!        // save  registers
    stp x4,x5,[sp,-16]!        // save  registers
    stp x6,x7,[sp,-16]!        // save  registers
    stp x8,x9,[sp,-16]!        // save  registers
    sub x3,x3,1                // compute endidx = n - 1
    sub x5,x2,x1               // compute max - min
    add x5,x5,1                // + 1
    lsl x9,x5,3                // 8 bytes by number
    sub sp,sp,x9               // reserve count area in stack
    mov fp,sp                  // frame pointer = stack
    mov x6,0
    mov x4,0
1:                             // loop init stack area
    str x6,[fp,x4, lsl 3]
    add x4,x4,#1
    cmp x4,x5
    blt 1b
    mov x4,#0                  // indice
2:                             // start loop 2
    ldr x5,[x0,x4,lsl 3]       // load value A[j]
    sub x5,x5,x1               // - min
    ldr x6,[fp,x5,lsl 3]       // load count of value
    add x6,x6,1                // increment counter
    str x6,[fp,x5,lsl 3]       // and store
    add x4,x4,1                // increment indice
    cmp x4,x3                  // end ?
    ble 2b                     // no -> loop 2

    mov x7,0                   // z
    mov x4,x1                  // index = min
3:                             // start loop 3
    sub x6,x4,x1               // compute index - min
    ldr x5,[fp,x6,lsl 3]       // load count
4:                             // start loop 4
    cmp x5,0                   // count <> zéro
    beq 5f
    str x4,[x0,x7,lsl 3]       // store value A[j]
    add x7,x7,1                // increment z
    sub x5,x5,1                // decrement count
    b  4b

5:
    add x4,x4,1                // increment index
    cmp x4,x2                  // max ?
    ble 3b                     // no -> loop 3

    add sp,sp,x9               // stack alignement

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
    mov x0,x2                       // table address
100:
    ldp x2,x3,[sp],16               // restaur  2 registers
    ldp x1,lr,[sp],16               // restaur  2 registers
    ret                             // return to address lr x30
/********************************************************/
/*        File Include fonctions                        */
/********************************************************/
/* for this file see task include a file in language AArch64 assembly */
.include "../includeARM64.inc"
