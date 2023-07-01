/* ARM assembly AARCH64 Raspberry PI 3B */
/*  program bogosort64.s   */

/*******************************************/
/* Constantes file                         */
/*******************************************/
/* for this file see task include a file in language AArch64 assembly*/
.include "../includeConstantesARM64.inc"
/*********************************/
/* Initialized data              */
/*********************************/
.data
sMessResult:      .asciz "Value  : @ \n"
szCarriageReturn: .asciz "\n"

.align 4
qGraine:  .quad 123456
TableNumber:       .quad   1,2,3,4,5,6,7,8,9,10
                   .equ NBELEMENTS, (. - TableNumber) / 8

/*********************************/
/* UnInitialized data            */
/*********************************/
.bss
sZoneConv:          .skip 24
/*********************************/
/*  code section                 */
/*********************************/
.text
.global main
main:                                           // entry of program

1:
    ldr x0,qAdrTableNumber                      // address number table
    mov x1,#NBELEMENTS                          // number of élements
    bl knuthShuffle
                                                // table  display elements
    ldr x0,qAdrTableNumber                      // address number table
    mov x1,#NBELEMENTS                          // number of élements
    bl displayTable

    ldr x0,qAdrTableNumber                      // address number table
    mov x1,#NBELEMENTS                          // number of élements
    bl isSorted                                 // control sort
    cmp x0,#1                                   // sorted ?
    bne 1b                                      // no -> loop


100:                                            // standard end of the program
    mov x0, #0                                  // return code
    mov x8, #EXIT                               // request to exit program
    svc #0                                      // perform the system call

qAdrszCarriageReturn:     .quad szCarriageReturn
qAdrsMessResult:          .quad sMessResult
qAdrTableNumber:          .quad TableNumber

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
/******************************************************************/
/*     shuffle game                                       */
/******************************************************************/
/* x0 contains boxs address           */
/* x1 contains elements number        */
knuthShuffle:
    stp x1,lr,[sp,-16]!            // save  registers
    stp x2,x3,[sp,-16]!            // save  registers
    stp x4,x5,[sp,-16]!            // save  registers
    mov x5,x0                      // save table address
    mov x2,#0                      // start index
1:
    mov x0,x2                      // generate aleas
    bl genereraleas
    ldr x3,[x5,x2,lsl #3]          // swap number on the table
    ldr x4,[x5,x0,lsl #3]
    str x4,[x5,x2,lsl #3]
    str x3,[x5,x0,lsl #3]
    add x2,x2,1                                         // next number
    cmp x2,x1                                         // end ?
    blt 1b                                            // no -> loop

100:
    ldp x4,x5,[sp],16              // restaur  2 registers
    ldp x2,x3,[sp],16              // restaur  2 registers
    ldp x1,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30
/***************************************************/
/*   Generation random number                  */
/***************************************************/
/* x0 contains limit  */
genereraleas:
    stp x1,lr,[sp,-16]!            // save  registers
    stp x2,x3,[sp,-16]!            // save  registers
    ldr x1,qAdrqGraine
    ldr x2,[x1]
    ldr x3,qNbDep1
    mul x2,x3,x2
    ldr x3,qNbDep2
    add x2,x2,x3
    str x2,[x1]                    // maj de la graine pour l appel suivant
    cmp x0,#0
    beq 100f
    udiv x3,x2,x0
    msub x0,x3,x0,x2               // résult = remainder

100:                               // end function
    ldp x2,x3,[sp],16              // restaur  2 registers
    ldp x1,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30
qAdrqGraine: .quad qGraine
qNbDep1:     .quad 0x0019660d
qNbDep2:     .quad 0x3c6ef35f
/********************************************************/
/*        File Include fonctions                        */
/********************************************************/
/* for this file see task include a file in language AArch64 assembly */
.include "../includeARM64.inc"
