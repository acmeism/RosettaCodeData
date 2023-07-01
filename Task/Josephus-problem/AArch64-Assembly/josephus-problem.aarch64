/* ARM assembly AARCH64 Raspberry PI 3B */
/*  program josephus64.s   */
/* run with josephus64 maxi intervalle */
/* example : josephus64 41 3

/*******************************************/
/* Constantes file                         */
/*******************************************/
/* for this file see task include a file in language AArch64 assembly*/
.include "../includeConstantesARM64.inc"

.equ FIRSTNODE,        0              //identification first node

/*******************************************/
/* Structures                               */
/********************************************/
/* structure linkedlist*/
    .struct  0
llist_next:                            // next element
    .struct  llist_next + 8
llist_value:                           // element value
    .struct  llist_value + 8
llist_fin:
/*********************************/
/* Initialized data              */
/*********************************/
.data
szMessDebutPgm:          .asciz "Start program.\n"
szMessFinPgm:            .asciz "Program End ok.\n"
szRetourLigne:            .asciz "\n"
szMessValElement:        .asciz "Value : @ \n"
szMessListeVide:         .asciz "List empty.\n"
szMessImpElement:        .asciz "Node display: @ Value : @ Next @ \n"
szMessErrComm:           .asciz "Incomplete Command line  : josephus64 <maxi> <intervalle>\n"
/*********************************/
/* UnInitialized data            */
/*********************************/
.bss
sZoneConv:         .skip 100
.align 4
qDebutListe1:       .skip llist_fin
/*********************************/
/*  code section                 */
/*********************************/
.text
.global main
main:                                   // entry of program
    mov fp,sp                           // copy stack address  register x29 fp
    ldr x0,qAdrszMessDebutPgm
    bl affichageMess
    ldr x0,[fp]                         // parameter number command line
    cmp x0,#2                           // correct ?
    ble erreurCommande                  // error

    add x0,fp,#16                       // address parameter 2
    ldr x0,[x0]
    bl conversionAtoD
    add x22,x0,FIRSTNODE                // save maxi
    add x0,fp,#24                       // address parameter 3
    ldr x0,[x0]
    bl conversionAtoD
    mov x21,x0                          // save gap

    mov x0,FIRSTNODE                    // create first node
    mov x1,0
    bl createNode
    mov x25,x0                          // first node address
    mov x26,x0
    mov x24,FIRSTNODE + 1
    mov x23,1
1:                                      // loop create others nodes
    mov x0,x24                          // key value
    mov x1,0
    bl createNode
    str x0,[x26,llist_next]             // store current node address in prev node
    mov x26,x0
    add x24,x24,1
    add x23,x23,1
    cmp x23,x22                         // maxi ?
    blt 1b
    str x25,[x26,llist_next]            // store first node address in last pointer
    mov x24,x26
2:
    mov x20,1                           // counter for gap
3:
    ldr x24,[x24,llist_next]
    add x20,x20,1
    cmp x20,x21                         // intervalle ?
    blt 3b
    ldr x25,[x24,llist_next]            // removing the node from the list
    ldr x22,[x25,llist_value]
    ldr x27,[x25,llist_next]            // load pointer next
    str x27,[x24,llist_next]            // ans store in prev node
    //mov x0,x25
    //bl displayNode
    cmp x27,x24
    csel x24,x24,x27,ne                 // next node address
    bne 2b                              // and loop

    mov x0,x24
    bl displayNode                      // display last node

    b 100f
erreurCommande:
    ldr x0,qAdrszMessErrComm
    bl affichageMess
    mov x0,#1                          // error code
    b 100f
100:                                   // program end standard
    ldr x0,qAdrszMessFinPgm
    bl affichageMess
    mov x0,0                          // return code Ok
    mov x8,EXIT                       // system call "Exit"
    svc #0

qAdrszMessDebutPgm:      .quad szMessDebutPgm
qAdrszMessFinPgm:        .quad szMessFinPgm
qAdrszRetourLigne:       .quad szRetourLigne
qAdrqDebutListe1:        .quad qDebutListe1
qAdrszMessErrComm:       .quad szMessErrComm

/******************************************************************/
/*     create node                                             */
/******************************************************************/
/* x0 contains key   */
/* x1 contains zero or address next node */
/* x0 returns address heap node  */
createNode:
    stp x20,lr,[sp,-16]!        // save  registres
    stp x21,x22,[sp,-16]!       // save  registres
    mov x20,x0                  // save key
    mov x21,x1                  // save key
    mov x0,#0                   // allocation place heap
    mov x8,BRK                  // call system 'brk'
    svc #0
    mov x22,x0                  // save address heap for node
    add x0,x0,llist_fin         // reservation place node length
    mov x8,BRK                  // call system 'brk'
    svc #0
    cmp x0,#-1                  // allocation error
    beq 100f

    str x20,[x22,llist_value]
    str x21,[x22,llist_next]
    mov x0,x22
100:
    ldp x21,x22,[sp],16         // restaur des  2 registres
    ldp x20,lr,[sp],16          // restaur des  2 registres
    ret                         // retour adresse lr x30

/******************************************************************/
/*     display infos node                                     */
/******************************************************************/
/* x0 contains node address */
displayNode:
    stp x1,lr,[sp,-16]!        // save  registres
    stp x2,x3,[sp,-16]!        // save  registres
    mov x2,x0
    ldr x1,qAdrsZoneConv
    bl conversion16
    ldr x0,qAdrszMessImpElement
    ldr x1,qAdrsZoneConv
    bl strInsertAtCharInc
    mov x3,x0
    ldr x0,[x2,llist_value]
    ldr x1,qAdrsZoneConv
    bl conversion10S
    mov x0,x3
    ldr x1,qAdrsZoneConv
    bl strInsertAtCharInc
    mov x3,x0
    ldr x0,[x2,llist_next]
    ldr x1,qAdrsZoneConv
    bl conversion16
    mov x0,x3
    ldr x1,qAdrsZoneConv
    bl strInsertAtCharInc
    bl affichageMess

100:
    ldp x2,x3,[sp],16          // restaur des  2 registres
    ldp x1,lr,[sp],16          // restaur des  2 registres
    ret                        // retour adresse lr x30
qAdrsZoneConv:               .quad sZoneConv
qAdrszMessImpElement:        .quad szMessImpElement
/********************************************************/
/*        File Include fonctions                        */
/********************************************************/
/* for this file see task include a file in language AArch64 assembly */
.include "../includeARM64.inc"
