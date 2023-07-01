/* ARM assembly AARCH64 Raspberry PI 3B */
/*  program beadSort64.s */
/* En français tri par gravité ou tri par bille (ne pas confondre
   avec tri par bulle (bubble sort)) */

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
sMessResult:        .asciz "Value  : @ \n"
szCarriageReturn:   .asciz "\n"

.align 4
#TableNumber:      .quad   1,3,6,2,5,9,10,8,4,7
TableNumber:     .quad   10,9,8,7,6,5,4,3,2,1
                  .equ NBELEMENTS, (. - TableNumber) / 8
           //.equ NBELEMENTS, 4 // for others tests
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
main:                         // entry of program

1:
    ldr x0,qAdrTableNumber    // address number table
    mov x1,#NBELEMENTS        // number of élements
    bl beadSort
    ldr x0,qAdrTableNumber    // address number table
    mov x1,#NBELEMENTS        // number of élements
    bl displayTable

    ldr x0,qAdrTableNumber    // address number table
    mov x1,#NBELEMENTS        // number of élements
    bl isSorted               // control sort
    cmp x0,#1                 // sorted ?
    beq 2f
    ldr x0,qAdrszMessSortNok  // no !! error sort
    bl affichageMess
    b 100f
2:                            // yes
    ldr x0,qAdrszMessSortOk
    bl affichageMess
100:                          // standard end of the program
    mov x0, #0                // return code
    mov x8, #EXIT             // request to exit program
    svc #0                    // perform the system call

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
    stp x2,lr,[sp,-16]!          // save  registers
    stp x3,x4,[sp,-16]!          // save  registers
    mov x2,#0
    ldr x4,[x0,x2,lsl #3]        // load A[0]
1:
    add x2,x2,#1
    cmp x2,x1                    // end ?
    bge 99f
    ldr x3,[x0,x2, lsl #3]       // load A[i]
    cmp x3,x4                    // compare A[i],A[i-1]
    blt 98f                      // smaller -> error -> return
    mov x4,x3                    // no -> A[i-1] = A[i]
    b 1b                         // and loop
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
/*         bead sort                                              */
/******************************************************************/
/* x0 contains the address of table */
/* x1 contains the number of element */
/* Caution registers x2-x12 are not saved */
beadSort:
    stp x1,lr,[sp,-16]!       // save  registers
    mov x12,x1                // save elements number
                              //search max
    ldr x10,[x0]              // load value A[0] in max
    mov x4,#1
1:                            // loop search max
    cmp x4,x12                // end ?
    bge 21f                   // yes
    ldr x2,[x0,x4,lsl #3]     // load value A[i]
    cmp x2,x10                // compare with max
    csel x10,x2,x10,gt        // if greather
    add x4,x4,#1
    b 1b                      // loop
21:
    mul x5,x10,x12            // max * elements number
    lsl x5,x5,#3              // 8 bytes for each number
    sub sp,sp,x5              // allocate on the stack
    mov fp,sp                 // frame pointer = stack address
                              // marks beads
    mov x3,x0                 // save table address
    mov x0,#0                 // start index x
2:
    mov x1,#0                 // index y
    ldr x8,[x3,x0,lsl #3]     // load A[x]
    mul x6,x0,x10             // compute bead x
3:
    add x9,x6,x1              // compute bead y
    mov x4,#1                 // value to store
    str x4,[fp,x9,lsl #3]     // store to stack area
    add x1,x1,#1
    cmp x1,x8
    blt 3b
31:                           // init to zéro the bead end
    cmp x1,x10                // max ?
    bge 32f
    add x9,x6,x1              // compute bead y
    mov x4,#0
    str x4,[fp,x9,lsl #3]
    add x1,x1,#1
    b 31b
32:
    add x0,x0,#1              // increment x
    cmp x0,x12                // end ?
    blt 2b
                              // count beads
    mov x1,#0                 // y
4:
    mov x0,#0                 // start index x
    mov x8,#0                 // sum
5:
    mul x6,x0,x10             // compute bead x
    add x9,x6,x1              // compute bead y
    ldr x4,[fp,x9,lsl #3]
    add x8,x8,x4
    mov x4,#0
    str x4,[fp,x9,lsl #3]     // raz bead
    add x0,x0,#1
    cmp x0,x12
    blt 5b
    sub x0,x12,x8             // compute end - sum
6:
    mul x6,x0,x10             // compute bead x
    add x9,x6,x1              // compute bead y
    mov x4,#1
    str x4,[fp,x9,lsl #3]     // store new bead at end
    add x0,x0,#1
    cmp x0,x12
    blt 6b

    add x1,x1,#1
    cmp x1,x10
    blt 4b

                              // final compute
    mov x0,#0                 // start index x
7:
    mov x1,#0                 // start index y
    mul x6,x0,x10             // compute bead x
8:
    add x9,x6,x1              // compute bead y
    ldr x4,[fp,x9,lsl #3]     // load bead [x,y]
    add x1,x1,#1              // add to x1 before str (index start at zéro)
    cmp x4,#1
    bne 9f
    str x1,[x3,x0, lsl #3]    // store A[x]
9:
    cmp x1,x10                // compare max
    blt 8b
    add x0,x0,#1
    cmp x0,x12                // end ?
    blt 7b

    mov x0,#0
    add sp,sp,x5              // stack alignement
100:
    ldp x1,lr,[sp],16         // restaur  2 registers
    ret                       // return to address lr x30
/******************************************************************/
/*      Display table elements                                */
/******************************************************************/
/* x0 contains the address of table */
/* x1 contains elements number  */
displayTable:
    stp x1,lr,[sp,-16]!          // save  registers
    stp x2,x3,[sp,-16]!          // save  registers
    mov x2,x0                    // table address
    mov x4,x1                    // elements number
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
    cmp x3,x4                    // end ?
    blt 1b                       // no -> loop
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
