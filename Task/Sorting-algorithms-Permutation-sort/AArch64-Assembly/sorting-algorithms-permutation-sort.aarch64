/* ARM assembly AARCH64 Raspberry PI 3B */
/*  program permutationSort64.s  */

/*******************************************/
/* Constantes file                         */
/*******************************************/
/* for this file see task include a file in language AArch64 assembly */
.include "../includeConstantesARM64.inc"

/*******************************************/
/* Structures                               */
/********************************************/
/* structure permutations  */
    .struct  0
perm_adrtable:                    // table value address
    .struct  perm_adrtable + 8
perm_size:                        // elements number
    .struct  perm_size + 8
perm_adrheap:                     // Init to zéro at the first call
    .struct  perm_adrheap + 8
perm_end:
/*********************************/
/* Initialized data              */
/*********************************/
.data
szMessSortOk:       .asciz "Table sorted.\n"
szMessSortNok:      .asciz "Table not sorted !!!!!.\n"
sMessCounter:       .asciz "sorted in  @ permutations \n"
sMessResult:        .asciz "Value  : @ \n"

szCarriageReturn:   .asciz "\n"

.align 4
#TableNumber:      .quad   1,3,6,2,5,9,10,8,4,7,11
TableNumber:     .quad   10,9,8,7,6,-5,4,3,2,1
                 .equ NBELEMENTS, (. - TableNumber) / 8
/*********************************/
/* UnInitialized data            */
/*********************************/
.bss
sZoneConv:       .skip 24
stPermutation:   .skip perm_end
/*********************************/
/*  code section                 */
/*********************************/
.text
.global main
main:                                              // entry of program
    ldr x0,qAdrstPermutation                       // address structure permutation
    ldr x1,qAdrTableNumber                         // address number table
    str x1,[x0,perm_adrtable]
    mov x1,NBELEMENTS                              // elements number
    str x1,[x0,perm_size]
    mov x1,0                                       // first call
    str x1,[x0,perm_adrheap]
    mov x20,0                                      // counter
1:
    ldr x0,qAdrstPermutation                       // address structure permutation
    bl newPermutation                              // call for each permutation
    cmp x0,0                                       // end ?
    blt 99f                                        // yes -> error
    //bl displayTable                              // for display after each permutation
    add x20,x20,1                                  // increment counter
    ldr x0,qAdrTableNumber                         // address number table
    mov x1,NBELEMENTS                              // number of élements
    bl isSorted                                    // control sort
    cmp x0,1                                       // sorted ?
    bne 1b                                         // no -> loop

    ldr x0,qAdrTableNumber                         // address number table
    bl displayTable
    ldr x0,qAdrszMessSortOk                        // address OK message
    bl affichageMess
    mov x0,x20                                     // display counter
    ldr x1,qAdrsZoneConv
    bl conversion10S                               // décimal conversion
    ldr x0,qAdrsMessCounter
    ldr x1,qAdrsZoneConv                           // insert conversion
    bl strInsertAtCharInc
    bl affichageMess                               // display message
    b 100f
99:
    ldr x0,qAdrTableNumber                         // address number table
    bl displayTable
    ldr x0,qAdrszMessSortNok                       // address not OK message
    bl affichageMess
100:                                               // standard end of the program
    mov x0,0                                       // return code
    mov x8,EXIT                                    // request to exit program
    svc 0                                          // perform the system call

qAdrsZoneConv:            .quad sZoneConv
qAdrszCarriageReturn:     .quad szCarriageReturn
qAdrsMessResult:          .quad sMessResult
qAdrTableNumber:          .quad TableNumber
qAdrstPermutation:        .quad stPermutation
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
/***************************************************/
/*   return permutation one by one                 */
/* sur une idée de vincent Moresmau                */
/* use algorytm heap iteratif see wikipedia        */
/***************************************************/
/* x0 contains the address of structure permutations */
/* x0 return address  of value table or zéro if end */
newPermutation:
    stp x1,lr,[sp,-16]!             // save  registers
    stp x2,x3,[sp,-16]!             // save  registers
    stp x4,x5,[sp,-16]!             // save  registers
    stp x6,x7,[sp,-16]!             // save  registers
    ldr x2,[x0,perm_adrheap]
    cmp x2,0
    bne 2f
                                    // first call -> init area on heap
    mov x7,x0
    ldr x1,[x7,perm_size]
    lsl x3,x1,3                     // 8 bytes by count table
    add x3,x3,8                     // 8 bytes for current index
    mov x0,0                        // allocation place heap
    mov x8,BRK                      // call system 'brk'
    svc 0
    mov x2,x0                       // save address heap
    add x0,x0,x3                    // reservation place
    mov x8,BRK                      // call system 'brk'
    svc #0
    cmp x0,-1                       // allocation error
    beq 100f
    add x8,x2,8                     // address begin area counters
    mov x3,0
1:                                  // loop init
    str xzr,[x8,x3,lsl 3]           // init to zéro area heap
    add x3,x3,1
    cmp x3,x1
    blt 1b
    str xzr,[x2]                    // store zero to index
    str x2,[x7,perm_adrheap]        // store heap address on structure permutation
    ldr x0,[x7,perm_adrtable]       // return first permutation
    b 100f

2:                                  // other calls x2 contains heap address
    mov x7,x0                       // structure address
    ldr x1,[x7,perm_size]           // elements number
    ldr x0,[x7,perm_adrtable]
    add x8,x2,8                     // begin address area count
    ldr x3,[x2]                     // load current index
3:
    ldr x4,[x8,x3,lsl 3]            // load count [i]
    cmp x4,x3                       // compare with i
    bge 6f
    tst x3,#1                       // even ?
    bne 4f
    ldr x5,[x0]                     // yes load value A[0]
    ldr x6,[x0,x3,lsl 3]            // and swap with value A[i]
    str x6,[x0]
    str x5,[x0,x3,lsl 3]
    b 5f
4:
    ldr x5,[x0,x4,lsl 3]            // no load value A[count[i]]
    ldr x6,[x0,x3,lsl 3]            // and swap with value A[i]
    str x6,[x0,x4,lsl 3]
    str x5,[x0,x3,lsl 3]
5:
    add x4,x4,1
    str x4,[x8,x3,lsl 3]            // store new count [i]
    str xzr,[x2]                    // store new index
    b 100f                          // and return new permutation in x0
6:
    str xzr,[x8,x3,lsl 3]           // store zero in count [i]
    add x3,x3,1                     // increment index
    cmp x3,x1                       // end
    blt 3b                          // loop
    mov x0,0                        // if end -> return zero

 100:                               // end function
    ldp x6,x7,[sp],16               // restaur  1 register
    ldp x4,x5,[sp],16               // restaur  1 register
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
