/* ARM assembly AARCH64 Raspberry PI 3B */
/*  program sha1_64.s   */

/*******************************************/
/* Constantes file                         */
/*******************************************/
/* for this file see task include a file in language AArch64 assembly*/
.include "../includeConstantesARM64.inc"

.equ SHA_DIGEST_LENGTH, 20

//.include "../../ficmacros64.s"

/*********************************/
/* Initialized data              */
/*********************************/
.data
szMessRosetta:         .asciz "Rosetta Code"
szMessTest1:           .asciz "abc"
szMessSup64:           .ascii "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                       .ascii "abcdefghijklmnopqrstuvwxyz"
                       .asciz "1234567890AZERTYUIOP"
szMessTest2:           .asciz "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"
szMessFinPgm:          .asciz "Program End ok.\n"
szMessResult:          .asciz "Rosetta Code => "
szCarriageReturn:      .asciz "\n"

/* array constantes Hi */
tbConstHi:           .int 0x67452301       // H0
                     .int 0xEFCDAB89       // H1
                     .int 0x98BADCFE       // H2
                     .int 0x10325476       // H3
                     .int 0xC3D2E1F0       // H4
/* array constantes Kt */
tbConstKt:           .int 0x5A827999
                     .int 0x6ED9EBA1
                     .int 0x8F1BBCDC
                     .int 0xCA62C1D6


/*********************************/
/* UnInitialized data            */
/*********************************/
.bss
.align 4
iNbBlocs:                    .skip 8
sZoneConv:                   .skip 24
sZoneResult:                 .skip 24
sZoneTrav:                   .skip 1000
tbH:                         .skip 4 * 5         // 5 variables H
tbW:                         .skip 4 * 80        // 80 words W
/*********************************/
/*  code section                 */
/*********************************/
.text
.global main
main:                                      // entry of program

    ldr x0,qAdrszMessRosetta
    //ldr x0,qAdrszMessTest1
    //ldr x0,qAdrszMessTest2
    //ldr x0,qAdrszMessSup64
    bl computeSHA1                         // call routine SHA1

    ldr x0,qAdrszMessResult
    bl affichageMess                       // display message

    ldr x0, qAdrsZoneResult
    bl displaySHA1

    ldr x0,qAdrszMessFinPgm
    bl affichageMess                       // display message


100:                                       // standard end of the program
    mov x0,0                               // return code
    mov x8,EXIT                            // request to exit program
    svc 0                                  // perform the system call

qAdrszCarriageReturn:     .quad szCarriageReturn
qAdrszMessResult:         .quad szMessResult
qAdrszMessRosetta:        .quad szMessRosetta
qAdrszMessTest1:          .quad szMessTest1
qAdrszMessTest2:          .quad szMessTest2
qAdrsZoneTrav:            .quad sZoneTrav
qAdrsZoneConv:            .quad sZoneConv
qAdrszMessFinPgm:         .quad szMessFinPgm
qAdrszMessSup64:          .quad szMessSup64
/******************************************************************/
/*     compute SHA1                         */
/******************************************************************/
/* x0 contains the address of the message */
computeSHA1:
    stp x1,lr,[sp,-16]!       // save  registers
    ldr x1,qAdrsZoneTrav
    mov x2,#0                // counter length
debCopy:                     // copy string in work area
    ldrb w3,[x0,x2]
    strb w3,[x1,x2]
    cmp x3,#0
    add x4,x2,1
    csel x2,x4,x2,ne
    bne debCopy
    lsl x6,x2,#3             // initial message length in bits
    mov x3,#0b10000000       // add bit 1 at end of string
    strb w3,[x1,x2]
    add x2,x2,#1             // length in bytes
    lsl x4,x2,#3             // length in bits
    mov x3,#0
addZeroes:
    lsr x5,x2,#6
    lsl x5,x5,#6
    sub x5,x2,x5
    cmp x5,#56
    beq storeLength          // yes -> end add
    strb w3,[x1,x2]          // add zero at message end
    add x2,x2,#1                // increment lenght bytes
    add x4,x4,#8                // increment length in bits
    b addZeroes
storeLength:
    add x2,x2,#4                // add four bytes
    rev w6,w6                // inversion bits initials message length
    str w6,[x1,x2]           // and store at end

    ldr x7,qAdrtbConstHi     // constantes H address
    ldr x4,qAdrtbH           // start area H
    mov x5,#0
loopConst:                   // init array H with start constantes
    ldr w6,[x7,x5,lsl #2]    // load constante
    str w6,[x4,x5,lsl #2]    // and store
    add x5,x5,#1
    cmp x5,#5
    blt loopConst
                             // split into block of 64 bytes
    add x2,x2,#4                //  TODO : à revoir
    lsr x4,x2,#6             // blocks number
    ldr x0,qAdriNbBlocs
    str x4,[x0]              // save block maxi
    mov x7,#0                // n° de block et x1 contient l'adresse zone de travail
loopBlock:                   // begin loop of each block of 64 bytes
    mov x0,x7
    bl inversion             // inversion each word because little indian
    ldr x3,qAdrtbW           // working area W address
    mov x6,#0                // indice t
                             /* x2  address begin each block */
    ldr x1,qAdrsZoneTrav
    add x2,x1,x7,lsl #6      //  compute block begin  indice * 4 * 16

loopPrep:                    // loop for expand 80 words
    cmp x6,#15               //
    bgt expand1
    ldr w0,[x2,x6,lsl #2]    // load four byte message
    str w0,[x3,x6,lsl #2]    // store in first 16 block
    b expandEnd
expand1:
    sub x8,x6,#3
    ldr w9,[x3,x8,lsl #2]
    sub x8,x6,#8
    ldr w10,[x3,x8,lsl #2]
    eor x9,x9,x10
    sub x8,x6,#14
    ldr w10,[x3,x8,lsl #2]
    eor x9,x9,x10
    sub x8,x6,#16
    ldr w10,[x3,x8,lsl #2]
    eor x9,x9,x10
    ror w9,w9,#31

    str w9,[x3,x6,lsl #2]
expandEnd:
    add x6,x6,#1
    cmp x6,#80                 // 80 words ?
    blt loopPrep               // and loop
    /* COMPUTING THE MESSAGE DIGEST */
    /* x1  area H constantes address */
    /* x3  working area W address  */
    /* x5  address constantes K   */
    /* x6  counter t */
    /* x7  block counter */
    /* x8  a, x9 b, x10 c, x11 d, x12 e */

                               // init variable a b c d e
    ldr x0,qAdrtbH
    ldr w8,[x0]
    ldr w9,[x0,#4]
    ldr w10,[x0,#8]
    ldr w11,[x0,#12]
    ldr w12,[x0,#16]

    ldr x1,qAdrtbConstHi
    ldr x5,qAdrtbConstKt
    mov x6,#0
loop80T:                       // begin loop 80 t
    cmp x6,#19
    bgt T2
    ldr w0,[x5]                // load constantes k0
    and x2,x9,x10              // b and c
    mvn w4,w9                  // not b
    and x4,x4,x11              // and d
    orr x2,x2,x4
    b T_fin
T2:
    cmp x6,#39
    bgt T3
    ldr w0,[x5,#4]             // load constantes k1
    eor x2,x9,x10
    eor x2,x2,x11
    b T_fin
T3:
    cmp x6,#59
    bgt T4
    ldr w0,[x5,#8]             // load constantes k2
    and x2,x9,x10
    and x4,x9,x11
    orr x2,x2,x4
    and x4,x10,x11
    orr x2,x2,x4
    b T_fin
T4:
    ldr w0,[x5,#12]            // load constantes k3
    eor x2,x9,x10
    eor x2,x2,x11
    b T_fin
T_fin:
    ror w4,w8,#27            // left rotate a to 5
    add w2,w2,w4
    //affregtit Tfin 0
    //affregtit Tfin 8
    add w2,w2,w12
    ldr w4,[x3,x6,lsl #2]    // Wt
    add w2,w2,w4
    add w2,w2,w0                // Kt
    mov x12,x11              // e = d
    mov x11,x10              // d = c
    ror w10,w9,#2            // c
    mov x9,x8                // b = a
    mov x8,x2                // nouveau a

    add x6,x6,#1             // increment t
    cmp x6,#80
    blt loop80T
                             // other bloc
    add x7,x7,1                // increment block
    ldr x0,qAdriNbBlocs
    ldr w4,[x0]              // restaur maxi block
    cmp x7,x4                // maxi ?
    bge End
                             // End block
    ldr x0,qAdrtbH           // start area H
    ldr w3,[x0]
    add w3,w3,w8
    str w3,[x0]              // store a in H0
    ldr w3,[x0,#4]
    add w3,w3,w9
    str w3,[x0,#4]           // store b in H1
    ldr w3,[x0,#8]
    add w3,w3,w10
    str w3,[x0,#8]           // store c in H2
    ldr w3,[x0,#12]
    add w3,w3,w11
    str w3,[x0,#12]          // store d in H3
    ldr w3,[x0,#16]
    add w3,w3,w12
    str w3,[x0,#16]          // store e in H4
    b loopBlock              //  loop

End:
                             // compute final result
    ldr x0,qAdrtbH           // start area H
    ldr x2,qAdrsZoneResult
    ldr w1,[x0]
    add x1,x1,x8
    rev w1,w1
    str w1,[x2]
    ldr w1,[x0,#4]
    add x1,x1,x9
    rev w1,w1
    str w1,[x2,#4]
    ldr w1,[x0,#8]
    add x1,x1,x10
    rev w1,w1
    str w1,[x2,#8]
    ldr w1,[x0,#12]
    add x1,x1,x11
    rev w1,w1
    str w1,[x2,#12]
    ldr w1,[x0,#16]
    add x1,x1,x12
    rev w1,w1
    str w1,[x2,#16]
    mov x0,#0                    // routine OK
100:

    ldp x1,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30
qAdrtbConstHi:            .quad tbConstHi
qAdrtbConstKt:            .quad tbConstKt
qAdrtbH:                  .quad tbH
qAdrtbW:                  .quad tbW
qAdrsZoneResult:          .quad sZoneResult
qAdriNbBlocs:             .quad iNbBlocs
/******************************************************************/
/*     inversion des mots de 32 bits d'un bloc                    */
/******************************************************************/
/* x0 contains N° block   */
inversion:
    stp x1,lr,[sp,-16]!          // save  registers
    stp x2,x3,[sp,-16]!          // save  registers
    ldr x1,qAdrsZoneTrav
    add x1,x1,x0,lsl 6           // debut du bloc
    mov x2,#0
1:                               // start loop
    ldr w3,[x1,x2,lsl #2]
    rev w3,w3
    str w3,[x1,x2,lsl #2]
    add x2,x2,#1
    cmp x2,#16
    blt 1b
100:
    ldp x2,x3,[sp],16            // restaur  2 registers
    ldp x1,lr,[sp],16            // restaur  2 registers
    ret                          // return to address lr x30
/******************************************************************/
/*     display hash  SHA1                         */
/******************************************************************/
/* x0 contains the address of hash  */
displaySHA1:
    stp x1,lr,[sp,-16]!       // save  registers
    stp x2,x3,[sp,-16]!       // save  registers
    mov x3,x0
    mov x2,#0
1:
    ldr w0,[x3,x2,lsl #2]          // load 4 bytes
    rev w0,w0                      // reverse bytes
    ldr x1,qAdrsZoneConv
    bl conversion16_4W                // conversion hexa
    ldr x0,qAdrsZoneConv
    bl affichageMess
    add x2,x2,#1
    cmp x2,#SHA_DIGEST_LENGTH / 4
    blt 1b                         // and loop
    ldr x0,qAdrszCarriageReturn
    bl affichageMess               // display message
100:
    ldp x2,x3,[sp],16              // restaur  2 registers
    ldp x1,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30
/******************************************************************/
/*     conversion  hexadecimal register 32 bits                   */
/******************************************************************/
/* x0 contains value and x1 address zone receptrice   */
conversion16_4W:
    stp x0,lr,[sp,-48]!        // save  registres
    stp x1,x2,[sp,32]          // save  registres
    stp x3,x4,[sp,16]          // save  registres
    mov x2,#28                 // start bit position
    mov x4,#0xF0000000         // mask
    mov x3,x0                  // save entry value
1:                             // start loop
    and x0,x3,x4               // value register and mask
    lsr x0,x0,x2               // right shift
    cmp x0,#10                 // >= 10 ?
    bge 2f                     // yes
    add x0,x0,#48              // no is digit
    b 3f
2:
    add x0,x0,#55              // else is a letter A-F
3:
    strb w0,[x1],#1            // load result  and + 1 in address
    lsr x4,x4,#4               // shift mask 4 bits left
    subs x2,x2,#4              // decrement counter 4 bits <= zero  ?
    bge 1b                     // no -> loop

100:                           // fin standard de la fonction
    ldp x3,x4,[sp,16]          // restaur des  2 registres
    ldp x1,x2,[sp,32]          // restaur des  2 registres
    ldp x0,lr,[sp],48          // restaur des  2 registres
    ret
/********************************************************/
/*        File Include fonctions                        */
/********************************************************/
/* for this file see task include a file in language AArch64 assembly */
.include "../includeARM64.inc"
