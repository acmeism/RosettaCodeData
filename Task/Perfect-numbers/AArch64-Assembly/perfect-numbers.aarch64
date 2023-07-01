/* ARM assembly AARCH64 Raspberry PI 3B */
/*  program perfectNumber64.s   */
/* use Euclide Formula : if M=(2puis p)-1 is prime M * (M+1)/2 is perfect see Wikipedia  */
/*******************************************/
/* Constantes file                         */
/*******************************************/
/* for this file see task include a file in language AArch64 assembly */
.include "../includeConstantesARM64.inc"

.equ MAXI,      63

/*********************************/
/* Initialized data              */
/*********************************/
.data
sMessResult:        .asciz "Perfect  : @ \n"
szMessOverflow:     .asciz "Overflow in function isPrime.\n"
szCarriageReturn:   .asciz "\n"

/*********************************/
/* UnInitialized data            */
/*********************************/
.bss
sZoneConv:                  .skip 24
/*********************************/
/*  code section                 */
/*********************************/
.text
.global main
main:                               // entry of program
    mov x4,2                        // start 2
    mov x3,1                        // counter 2 power
1:                                  // begin loop
    lsl x4,x4,1                     // 2 power
    sub x0,x4,1                     // - 1
    bl isPrime                      // is prime ?
    cbz x0,2f                       // no
    sub x0,x4,1                     // yes
    mul x1,x0,x4                    // multiply m by m-1
    lsr x0,x1,1                     // divide by 2
    bl displayPerfect               // and display
2:
    add x3,x3,1                     // next power of 2
    cmp x3,MAXI
    blt 1b

100:                                // standard end of the program
    mov x0,0                        // return code
    mov x8,EXIT                     // request to exit program
    svc 0                           // perform the system call
qAdrszCarriageReturn:    .quad szCarriageReturn
qAdrsMessResult:         .quad sMessResult

/******************************************************************/
/*      Display perfect number                                */
/******************************************************************/
/* x0 contains the number */
displayPerfect:
    stp x1,lr,[sp,-16]!             // save  registers
    ldr x1,qAdrsZoneConv
    bl conversion10                 // call décimal conversion
    ldr x0,qAdrsMessResult
    ldr x1,qAdrsZoneConv            // insert conversion in message
    bl strInsertAtCharInc
    bl affichageMess                // display message
100:
    ldp x1,lr,[sp],16               // restaur  2 registers
    ret                             // return to address lr x30
qAdrsZoneConv:                   .quad sZoneConv

/***************************************************/
/*   is a number prime ?         */
/***************************************************/
/* x0 contains the number */
/* x0 return 1 if prime  else 0  */
//2147483647  OK
//4294967297  NOK
//131071       OK
//1000003    OK
//10001363   OK
isPrime:
    stp x1,lr,[sp,-16]!        // save  registres
    stp x2,x3,[sp,-16]!        // save  registres
    mov x2,x0
    sub x1,x0,#1
    cmp x2,0
    beq 99f                    // return zero
    cmp x2,2                   // for 1 and 2 return 1
    ble 2f
    mov x0,#2
    bl moduloPuR64
    bcs 100f                   // error overflow
    cmp x0,#1
    bne 99f                    // no prime
    cmp x2,3
    beq 2f
    mov x0,#3
    bl moduloPuR64
    blt 100f                   // error overflow
    cmp x0,#1
    bne 99f

    cmp x2,5
    beq 2f
    mov x0,#5
    bl moduloPuR64
    bcs 100f                   // error overflow
    cmp x0,#1
    bne 99f                    // Pas premier

    cmp x2,7
    beq 2f
    mov x0,#7
    bl moduloPuR64
    bcs 100f                   // error overflow
    cmp x0,#1
    bne 99f                    // Pas premier

    cmp x2,11
    beq 2f
    mov x0,#11
    bl moduloPuR64
    bcs 100f                   // error overflow
    cmp x0,#1
    bne 99f                    // Pas premier

    cmp x2,13
    beq 2f
    mov x0,#13
    bl moduloPuR64
    bcs 100f                   // error overflow
    cmp x0,#1
    bne 99f                    // Pas premier
2:
    cmn x0,0                   // carry à zero no error
    mov x0,1                   // prime
    b 100f
99:
    cmn x0,0                   // carry à zero no error
    mov x0,#0                  // prime
100:
    ldp x2,x3,[sp],16          // restaur des  2 registres
    ldp x1,lr,[sp],16          // restaur des  2 registres
    ret


/**************************************************************/
/********************************************************/
/*   Compute modulo de b power e modulo m  */
/*    Exemple 4 puissance 13 modulo 497 = 445         */
/********************************************************/
/* x0  number  */
/* x1 exposant */
/* x2 modulo   */
moduloPuR64:
    stp x1,lr,[sp,-16]!        // save  registres
    stp x3,x4,[sp,-16]!        // save  registres
    stp x5,x6,[sp,-16]!        // save  registres
    stp x7,x8,[sp,-16]!        // save  registres
    stp x9,x10,[sp,-16]!       // save  registres
    cbz x0,100f
    cbz x1,100f
    mov x8,x0
    mov x7,x1
    mov x6,1                   // result
    udiv x4,x8,x2
    msub x9,x4,x2,x8           // remainder
1:
    tst x7,1                   // if bit = 1
    beq 2f
    mul x4,x9,x6
    umulh x5,x9,x6
    mov x6,x4
    mov x0,x6
    mov x1,x5
    bl divisionReg128U         // division 128 bits
    cbnz x1,99f                // overflow
    mov x6,x3                  // remainder
2:
    mul x8,x9,x9
    umulh x5,x9,x9
    mov x0,x8
    mov x1,x5
    bl divisionReg128U
    cbnz x1,99f                // overflow
    mov x9,x3
    lsr x7,x7,1
    cbnz x7,1b
    mov x0,x6                  // result
    cmn x0,0                   // carry à zero no error
    b 100f
99:
    ldr x0,qAdrszMessOverflow
    bl  affichageMess          // display error message
    cmp x0,0                   // carry set error
    mov x0,-1                  // code erreur

100:
    ldp x9,x10,[sp],16          // restaur des  2 registres
    ldp x7,x8,[sp],16          // restaur des  2 registres
    ldp x5,x6,[sp],16          // restaur des  2 registres
    ldp x3,x4,[sp],16          // restaur des  2 registres
    ldp x1,lr,[sp],16          // restaur des  2 registres
    ret                        // retour adresse lr x30
qAdrszMessOverflow:         .quad  szMessOverflow
/***************************************************/
/*   division d un nombre de 128 bits par un nombre de 64 bits */
/***************************************************/
/* x0 contient partie basse dividende */
/* x1 contient partie haute dividente */
/* x2 contient le diviseur */
/* x0 retourne partie basse quotient */
/* x1 retourne partie haute quotient */
/* x3 retourne le reste */
divisionReg128U:
    stp x6,lr,[sp,-16]!        // save  registres
    stp x4,x5,[sp,-16]!        // save  registres
    mov x5,#0                  // raz du reste R
    mov x3,#128                // compteur de boucle
    mov x4,#0                  // dernier bit
1:
    lsl x5,x5,#1               // on decale le reste de 1
    tst x1,1<<63               // test du bit le plus à gauche
    lsl x1,x1,#1               // on decale la partie haute du quotient de 1
    beq 2f
    orr  x5,x5,#1              // et on le pousse dans le reste R
2:
    tst x0,1<<63
    lsl x0,x0,#1               // puis on decale la partie basse
    beq 3f
    orr x1,x1,#1               // et on pousse le bit de gauche dans la partie haute
3:
    orr x0,x0,x4               // position du dernier bit du quotient
    mov x4,#0                  // raz du bit
    cmp x5,x2
    blt 4f
    sub x5,x5,x2               // on enleve le diviseur du reste
    mov x4,#1                  // dernier bit à 1
4:
                               // et boucle
    subs x3,x3,#1
    bgt 1b
    lsl x1,x1,#1               // on decale le quotient de 1
    tst x0,1<<63
    lsl x0,x0,#1               // puis on decale la partie basse
    beq 5f
    orr x1,x1,#1
5:
    orr x0,x0,x4               // position du dernier bit du quotient
    mov x3,x5
100:
    ldp x4,x5,[sp],16          // restaur des  2 registres
    ldp x6,lr,[sp],16          // restaur des  2 registres
    ret                        // retour adresse lr x30

/********************************************************/
/*        File Include fonctions                        */
/********************************************************/
/* for this file see task include a file in language AArch64 assembly */
.include "../includeARM64.inc"
