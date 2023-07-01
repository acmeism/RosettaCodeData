/* ARM assembly AARCH64 Raspberry PI 3B */
/*  program shellSort64.s   */

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
sMessResult:        .asciz "Value  :  @ \n"
szCarriageReturn:   .asciz "\n"

.align 4
TableNumber:      .quad   1,3,6,2,5,9,10,8,4,7
//TableNumber:     .quad   10,9,8,7,6,5,4,3,2,1
                   .equ NBELEMENTS, (. - TableNumber) / 8
/*********************************/
/* UnInitialized data            */
/*********************************/
.bss
sZoneConv:              .skip 24
/*********************************/
/*  code section                 */
/*********************************/
.text
.global main
main:                                             // entry of program

1:
    ldr x0,qAdrTableNumber                        // address number table
    mov x1,0                                      // not use in routine
    mov x2,NBELEMENTS                             // number of élements
    bl shellSort
    ldr x0,qAdrTableNumber                        // address number table
    bl displayTable

    ldr x0,qAdrTableNumber                        // address number table
    mov x1,#NBELEMENTS                            // number of élements
    bl isSorted                                   // control sort
    cmp x0,#1                                     // sorted ?
    beq 2f
    ldr x0,qAdrszMessSortNok                      // no !! error sort
    bl affichageMess
    b 100f
2:                                                // yes
    ldr x0,qAdrszMessSortOk
    bl affichageMess
100:                                              // standard end of the program
    mov x0,0                                      // return code
    mov x8,EXIT                                   // request to exit program
    svc 0                                         // perform the system call

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
    stp x1,lr,[sp,-16]!            // save  registers
    stp x2,x3,[sp,-16]!            // save  registers
    stp x4,x5,[sp,-16]!            // save  registers
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
   mov x0,0                        // error not sorted
   b 100f
99:
    mov x0,1                       // sorted
100:
    ldp x4,x5,[sp],16              // restaur  2 registers
    ldp x2,x3,[sp],16              // restaur  2 registers
    ldp x1,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30
/***************************************************/
/*   shell Sort                                    */
/***************************************************/

/* x0 contains the address of table */
/* x1 contains the first element but not use !!   */
/*   this routine use first element at index zero !!!  */
/* x2 contains the number of element */
shellSort:
    stp x1,lr,[sp,-16]!          // save  registers
    stp x2,x3,[sp,-16]!          // save  registers
    stp x4,x5,[sp,-16]!          // save  registers
    stp x6,x7,[sp,-16]!          // save  registers
    sub x2,x2,1                  // index last item
    mov x1,x2                    // init gap = last item
1:                               // start loop 1
    lsr x1,x1,1                     // gap = gap / 2
    cbz x1,100f                  // if gap = 0 -> end
    mov x3,x1                    // init loop indice 1
2:                               // start loop 2
    ldr x4,[x0,x3,lsl 3]        // load first value
    mov x5,x3                    // init loop indice 2
3:                               // start loop 3
    cmp x5,x1                    // indice < gap
    blt 4f                       // yes -> end loop 2
    sub x6,x5,x1                 // index = indice - gap
    ldr x7,[x0,x6,lsl 3]         // load second value
    cmp x4,x7                    // compare values
    bge 4f
    str x7,[x0,x5,lsl 3]         // store if <
    sub x5,x5,x1                    // indice = indice - gap
    b 3b                         // and loop
4:                               // end loop 3
    str x4,[x0,x5,lsl 3]         // store value 1 at indice 2
    add x3,x3,1                  // increment indice 1
    cmp x3,x2                    // end ?
    ble 2b                       // no -> loop 2
    b 1b                         // yes loop for new gap

100:                             // end function
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
    mov x3,0
1:                               // loop display table
    ldr x0,[x2,x3,lsl #3]
    ldr x1,qAdrsZoneConv         // display value
    bl conversion10              // call function
    ldr x0,qAdrsMessResult
    ldr x1,qAdrsZoneConv
    bl strInsertAtCharInc        // insert result at @ character
    bl affichageMess             // display message
    add x3,x3,1
    cmp x3,#NBELEMENTS - 1
    ble 1b
    ldr x0,qAdrszCarriageReturn
    bl affichageMess
100:
    ldp x2,x3,[sp],16            // restaur  2 registers
    ldp x1,lr,[sp],16            // restaur  2 registers
    ret                          // return to address lr x30
/********************************************************/
/*        File Include fonctions                        */
/********************************************************/
/* for this file see task include a file in language AArch64 assembly */
.include "../includeARM64.inc"
