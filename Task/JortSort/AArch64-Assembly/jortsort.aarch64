/* ARM assembly AARCH64 Raspberry PI 3B */
/*  program jortSort64.s   */

/*******************************************/
/* Constantes file                         */
/*******************************************/
/* for this file see task include a file in language AArch64 assembly*/
.include "../includeConstantesARM64.inc"

/*******************************************/
/* Initialized data                        */
/*******************************************/
.data
szMessOk:         .asciz "Ok, the list is sorted. \n"
szMessNotOk:      .asciz "Ouah!! this list is unsorted.\n"
szCarriageReturn:  .asciz "\n"
tbNumber:           .quad 3
                    .quad 4
                    .quad 20
                    .quad 5
                    .equ LGTBNUMBER, (. - tbNumber)/8  // number element of area
/*******************************************/
/* UnInitialized data                      */
/*******************************************/
.bss
sZoneConversion:        .skip 100
.align 4
tbNumberSorted:      .skip 8 * LGTBNUMBER
/*******************************************/
/*  code section                           */
/*******************************************/
.text
.global main
main:                             // entry of program
    ldr x0,qAdrtbNumber
    ldr x1,qAdrtbNumberSorted
    mov x2,LGTBNUMBER
    bl insertionSort              // sort area
    ldr x0,qAdrtbNumber
    ldr x1,qAdrtbNumberSorted
    mov x2,LGTBNUMBER
    bl comparArea                // control area
    cbz x0,1f
    ldr x0,qAdrszMessNotOk       // not sorted
    bl affichageMess
    b 100f
1:                               // ok it is good
    ldr x0,qAdrszMessOk
    bl affichageMess
100:                             // standard end of the program
    mov x0, #0                   // return code
    mov x8, #EXIT                // request to exit program
    svc 0                        // perform the system call

qAdrtbNumber:          .quad tbNumber
qAdrtbNumberSorted:    .quad tbNumberSorted
qAdrszMessNotOk:       .quad szMessNotOk
qAdrszMessOk:          .quad szMessOk
qAdrszCarriageReturn:  .quad szCarriageReturn
/******************************************************************/
/*     insertion sort                                             */
/******************************************************************/
/* x0 contains the address of area to sort  */
/* x1 contains the address of area sorted   */
/* x2 contains the number of element */
insertionSort:
    stp x1,lr,[sp,-16]!         // save  registers
    stp x2,x3,[sp,-16]!         // save  registers
    mov x3,0
1:                              // copy area unsorted to other area
    ldr x4,[x0,x3,lsl 3]
    str x4,[x1,x3,lsl 3]
    add x3,x3,1
    cmp x3,x2
    blt 1b

    mov x3,1                   // and sort area
2:
    ldr x4,[x1,x3,lsl 3]
    subs x5,x3,1
3:
    cbz x5,4f
    ldr x6,[x1,x5,lsl 3]
    cmp x6,x4
    ble 4f
    add x7,x5,1
    str x6,[x1,x7,lsl 3]
    subs x5,x5,1
    b 3b
4:
    add x5,x5,1
    str x4,[x1,x5,lsl 3]
    add x3,x3,1
    cmp x3,x2
    blt 2b
100:
    ldp x2,x3,[sp],16           // restaur  2 registers
    ldp x1,lr,[sp],16           // restaur  2 registers
    ret
/******************************************************************/
/*     Comparaison elements of two areas                          */
/******************************************************************/
/* x0 contains the address of area to sort  */
/* x1 contains the address of area sorted   */
/* x2 contains the number of element */
comparArea:
    stp x1,lr,[sp,-16]!         // save  registers
    stp x2,x3,[sp,-16]!         // save  registers
    mov x3,0
1:
    ldr x4,[x0,x3,lsl 3]        // load element area 1
    ldr x5,[x1,x3,lsl 3]        // load element area 2
    cmp x4,x5                   // equal ?
    bne 99f                     // no -> error
    add x3,x3,1                 // yes increment indice
    cmp x3,x2                   // maxi ?
    blt 1b                      // no -> loop
    mov x0,0                    // yes -> it is ok
    b 100f
99:
    mov x0,1
100:
    ldp x2,x3,[sp],16           // restaur  2 registers
    ldp x1,lr,[sp],16           // restaur  2 registers
    ret


/********************************************************/
/*        File Include fonctions                        */
/********************************************************/
/* for this file see task include a file in language AArch64 assembly */
.include "../includeARM64.inc"
