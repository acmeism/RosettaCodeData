/* ARM assembly AARCH64 Raspberry PI 3B */
/*  program patienceSort64.s  */

/*******************************************/
/* Constantes file                         */
/*******************************************/
/* for this file see task include a file in language AArch64 assembly */
.include "../includeConstantesARM64.inc"

/*******************************************/
/* Structures                               */
/********************************************/
/* structure Doublylinkedlist*/
    .struct  0
dllist_head:                    // head node
    .struct  dllist_head + 8
dllist_tail:                    // tail node
    .struct  dllist_tail  + 8
dllist_fin:
/* structure Node Doublylinked List*/
    .struct  0
NDlist_next:                    // next element
    .struct  NDlist_next + 8
NDlist_prev:                    // previous element
    .struct  NDlist_prev + 8
NDlist_value:                   // element value or key
    .struct  NDlist_value + 8
NDlist_fin:

/*********************************/
/* Initialized data              */
/*********************************/
.data
szMessSortOk:       .asciz "Table sorted.\n"
szMessSortNok:      .asciz "Table not sorted !!!!!.\n"
sMessResult:        .asciz "Value  : @ \n"
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
    bl patienceSort
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
/******************************************************************/
/*         patience sort                                                   */
/******************************************************************/
/* x0 contains the address of table */
/* x1 contains first start index
/* x2 contains the number of elements  */
patienceSort:
    stp x1,lr,[sp,-16]!        // save  registers
    stp x2,x3,[sp,-16]!        // save  registers
    stp x4,x5,[sp,-16]!        // save  registers
    stp x6,x7,[sp,-16]!        // save  registers
    stp x8,x9,[sp,-16]!        // save  registers
    lsl x9,x2,1                // compute total size of piles (2 list pointer by pile )
    lsl x10,x9,3               // 8 bytes by number
    sub sp,sp,x10              // reserve place to stack
    mov fp,sp                  // frame pointer = stack
    mov x3,0                   // index
    mov x4,0
1:
    str x4,[fp,x3,lsl 3]       // init piles area
    add x3,x3,1                // increment index
    cmp x3,x9
    blt 1b
    mov x3,0                   // index value
    mov x4,0                   // counter first pile
    mov x8,x0                  // save table address
2:
    ldr x1,[x8,x3,lsl 3]       // load value
    add x0,fp,x4,lsl 4         // pile address
    bl isEmpty
    cmp x0,0                   // pile empty ?
    bne 3f
    add x0,fp,x4,lsl 4         // pile address
    bl insertHead              // insert value x1
    b 5f
3:
    add x0,fp,x4,lsl 4         // pile address
    ldr x5,[x0,dllist_head]
    ldr x5,[x5,NDlist_value]   // load first list value
    cmp x1,x5                  // compare value and last value on the pile
    blt 4f
    add x0,fp,x4,lsl 4         // pile address
    bl insertHead              // insert value x1
    b 5f
4:                             // value is smaller créate a new pile
    add x4,x4,1
    add x0,fp,x4,lsl 4         // pile address
    bl insertHead              // insert value x1
5:
    add x3,x3,1                // increment index value
    cmp x3,x2                  // end
    blt 2b                     // and loop

    /* step 2 */
    mov x6,0                   // index value table
6:
    mov x3,0                   // index pile
    mov x5, 1<<62              // min
7:                             // search minimum
    add x0,fp,x3,lsl 4
    bl isEmpty
    cmp x0,0
    beq 8f
    add x0,fp,x3,lsl 4
    bl searchMinList
    cmp x0,x5                 // compare min global
    bge 8f
    mov x5,x0                 // smaller -> store new min
    mov x7,x1                 // and pointer to min
    add x9,fp,x3,lsl 4        // and head list
8:
    add x3,x3,1               // next pile
    cmp x3,x4                 // end ?
    ble 7b
    str x5,[x8,x6,lsl 3]      // store min to table value
    mov x0,x9                 // and suppress the value in the pile
    mov x1,x7
    bl suppressNode
    add x6,x6,1               // increment index value
    cmp x6,x2                 // end ?
    blt 6b

    add sp,sp,x10             // stack alignement
100:
    ldp x8,x9,[sp],16         // restaur  2 registers
    ldp x6,x7,[sp],16         // restaur  2 registers
    ldp x4,x5,[sp],16         // restaur  2 registers
    ldp x2,x3,[sp],16         // restaur  2 registers
    ldp x1,lr,[sp],16         // restaur  2 registers
    ret                       // return to address lr x30

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
/******************************************************************/
/*     list is empty ?                         */
/******************************************************************/
/* x0 contains the address of the list structure */
/* x0 return 0 if empty  else return 1 */
isEmpty:
    ldr x0,[x0,#dllist_head]
    cmp x0,0
    cset x0,ne
    ret                                // return
/******************************************************************/
/*     insert value at list head                        */
/******************************************************************/
/* x0 contains the address of the list structure */
/* x1 contains value */
insertHead:
    stp x1,lr,[sp,-16]!                  // save  registers
    stp x2,x3,[sp,-16]!                  // save  registers
    stp x4,x5,[sp,-16]!                  // save  registers
    mov x4,x0                            // save address
    mov x0,x1                            // value
    bl createNode
    cmp x0,#-1                           // allocation error ?
    beq 100f
    ldr x2,[x4,#dllist_head]             // load address first node
    str x2,[x0,#NDlist_next]             // store in next pointer on new node
    mov x1,#0
    str x1,[x0,#NDlist_prev]             // store zero in previous pointer on new node
    str x0,[x4,#dllist_head]             // store address new node in address head list
    cmp x2,#0                            // address first node is null ?
    beq 1f
    str x0,[x2,#NDlist_prev]             // no store adresse new node in previous pointer
    b 100f
1:
    str x0,[x4,#dllist_tail]             // else store new node in tail address
100:
    ldp x4,x5,[sp],16                    // restaur  2 registers
    ldp x2,x3,[sp],16                    // restaur  2 registers
    ldp x1,lr,[sp],16                    // restaur  2 registers
    ret                                  // return to address lr x30

/******************************************************************/
/*     search value minimum                                               */
/******************************************************************/
/* x0 contains the address of the list structure */
/* x0 return min   */
/* x1 return address of node */
searchMinList:
    stp x2,lr,[sp,-16]!                  // save  registers
    stp x3,x4,[sp,-16]!                  // save  registers
    ldr x0,[x0,#dllist_head]             // load first node
    mov x3,1<<62
    mov x1,0
1:
    cmp x0,0                             // null -> end
    beq 99f
    ldr x2,[x0,#NDlist_value]            // load node value
    cmp x2,x3                            // min ?
    bge 2f
    mov x3,x2                            // value -> min
    mov x1,x0                            // store pointer
2:
    ldr x0,[x0,#NDlist_next]             // load addresse next node
    b 1b                                 // and loop
99:
    mov x0,x3                            // return minimum
100:
    ldp x3,x4,[sp],16                    // restaur  2 registers
    ldp x2,lr,[sp],16                    // restaur  2 registers
    ret                                  // return to address lr x30
/******************************************************************/
/*     suppress node                                               */
/******************************************************************/
/* x0 contains the address of the list structure */
/* x1 contains the address to node to suppress  */
suppressNode:
    stp x2,lr,[sp,-16]!              // save  registers
    stp x3,x4,[sp,-16]!              // save  registers
    ldr x2,[x1,#NDlist_next]         // load addresse next node
    ldr x3,[x1,#NDlist_prev]         // load addresse prev node
    cmp x3,#0
    beq 1f
    str x2,[x3,#NDlist_next]
    b 2f
1:
    str x3,[x0,#NDlist_next]
2:
    cmp x2,#0
    beq 3f
    str x3,[x2,#NDlist_prev]
    b 100f
3:
    str x2,[x0,#NDlist_prev]
100:

    ldp x3,x4,[sp],16               // restaur  2 registers
    ldp x2,lr,[sp],16               // restaur  2 registers
    ret                             // return to address lr x30
/******************************************************************/
/*     Create new node                                            */
/******************************************************************/
/* x0 contains the value */
/* x0 return node address or -1 if allocation error*/
createNode:
    stp x1,lr,[sp,-16]!              // save  registers
    stp x2,x3,[sp,-16]!              // save  registers
    stp x4,x8,[sp,-16]!              // save  registers
    mov x4,x0                        // save value
                                     // allocation place on the heap
    mov x0,0                         // allocation place heap
    mov x8,BRK                       // call system 'brk'
    svc 0
    mov x3,x0                        // save address heap for output string
    add x0,x0,NDlist_fin                // reservation place one element
    mov x8,BRK                       // call system 'brk'
    svc #0
    cmp x0,-1                        // allocation error
    beq 100f
    mov x0,x3
    str x4,[x0,#NDlist_value]        // store value
    mov x2,0
    str x2,[x0,#NDlist_next]         // store zero to pointer next
    str x2,[x0,#NDlist_prev]         // store zero to pointer previous
100:
    ldp x4,x8,[sp],16                // restaur  2 registers
    ldp x2,x3,[sp],16                // restaur  2 registers
    ldp x1,lr,[sp],16                // restaur  2 registers
    ret                              // return to address lr x30
/********************************************************/
/*        File Include fonctions                        */
/********************************************************/
/* for this file see task include a file in language AArch64 assembly */
.include "../includeARM64.inc"
