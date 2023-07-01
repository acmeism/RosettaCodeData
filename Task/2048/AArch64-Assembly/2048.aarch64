/* ARM assembly AARCH64 Raspberry PI 3B */
/*  program 2048_64.s   */

/*******************************************/
/* Constantes file                         */
/*******************************************/
/* for this file see task include a file in language AArch64 assembly*/
.include "../includeConstantesARM64.inc"
.equ SIZE,       4
.equ TOTAL,      2048
.equ BUFFERSIZE, 80

.equ KEYSIZE,    8
.equ IOCTL,     0x1D  // Linux syscall
.equ SIGACTION, 0x86  // Linux syscall
.equ SYSPOLL,   0x16  // Linux syscall
.equ CREATPOLL, 0x14  // Linux syscall
.equ CTLPOLL,   0x15  // Linux syscall

.equ TCGETS,    0x5401
.equ TCSETS,    0x5402
.equ ICANON,    2
.equ ECHO,     10
.equ POLLIN,    1
.equ EPOLL_CTL_ADD,    1

.equ SIGINT,   2      // Issued if the user sends an interrupt signal (Ctrl + C)
.equ SIGQUIT,  3      // Issued if the user sends a quit signal (Ctrl + D)
.equ SIGTERM, 15      // Software termination signal (sent by kill by default)
.equ SIGTTOU, 22

/*******************************************/
/* Structures                               */
/********************************************/
/* structure termios see doc linux*/
    .struct  0
term_c_iflag:                    // input modes
    .struct  term_c_iflag + 4
term_c_oflag:                    // output modes
    .struct  term_c_oflag + 4
term_c_cflag:                    // control modes
    .struct  term_c_cflag + 4
term_c_lflag:                    // local modes
    .struct  term_c_lflag + 4
term_c_cc:                       // special characters
    .struct  term_c_cc + 40      // see length if necessary
term_fin:

/* structure sigaction see doc linux */
    .struct  0
sa_handler:
    .struct  sa_handler + 8
sa_mask:
    .struct  sa_mask + 8
sa_flags:
    .struct  sa_flags + 8
sa_sigaction:
    .struct  sa_sigaction + 8
sa_fin:

/* structure poll see doc linux */
    .struct  0
poll_event:                        //  events mask
    .struct  poll_event + 8
poll_fd:                           // events returned
    .struct  poll_fd  + 8
poll_fin:
/*********************************/
/* Initialized data              */
/*********************************/
.data
szMessOK:           .asciz "Bravo !! You win. \n"
szMessNotOK:        .asciz "You lost !! \n"
szMessNewGame:      .asciz "New game (y/n) ? \n"
szMessErreur:       .asciz "Error detected.\n"
szMessErrInitTerm:  .asciz "Error terminal init.\n"
szMessErrInitPoll:  .asciz "Error poll init.\n"
szMessErreurKey:    .asciz "Error read key.\n"
szMessErr:          .asciz    "Error code hexa : @ décimal : @ \n"
szCarriageReturn:   .asciz "\n"
szMess0:            .asciz "      "
szMess2:            .asciz "   2  "
szMess4:            .asciz "   4  "
szMess8:            .asciz "   8  "
szMess16:           .asciz "  16  "
szMess32:           .asciz "  32  "
szMess64:           .asciz "  64  "
szMess128:          .asciz " 128  "
szMess256:          .asciz " 256  "
szMess512:          .asciz " 512  "
szMess1024:         .asciz " 1024 "
szMess2048:         .asciz " 2048 "
szCleax1:           .byte 0x1B
                    .byte 'c'           // other console clear
                    .byte 0

szLineH:            .asciz "-----------------------------\n"
szLineV:            .asciz "|"
szLineVT:           .asciz "|      |      |      |      |\n"
.align 4
qGraine:            .quad 123456
/*********************************/
/* UnInitialized data            */
/*********************************/
.bss
.align 4
sZoneConv:      .skip 24
sBuffer:        .skip BUFFERSIZE
qTbCase:        .skip 8 * SIZE * SIZE
qEnd:           .skip 8                        // 0 loop  1 = end loop
qTouche:        .skip KEYSIZE                  // value key pressed
stOldtio:       .skip term_fin                 // old terminal state
stCurtio:       .skip term_fin                 // current terminal state
stSigAction:    .skip sa_fin                   // area signal structure
stSigAction1:   .skip sa_fin
stSigAction2:   .skip sa_fin
stSigAction3:   .skip sa_fin
stPoll1:        .skip poll_fin                 // area poll structure
stPoll2:        .skip poll_fin
stevents:       .skip 16
/*********************************/
/*  code section                 */
/*********************************/
.text
.global main
main:                                // entry of program
    mov x0,#0
    bl initTerm                      // terminal init
    cmp x0,0                         // error ?
    blt 100f
    bl initPoll                      // epoll instance init
    cmp x0,0
    blt 99f
    mov x22,x0                        // save epfd
1:                                    // begin game loop
    ldr x0,qAdrszCleax1
    bl affichageMess
    bl razTable
2:
    bl addDigit
    cmp x0,#-1
    beq 5f                            // end game
    bl displayGame
3:
    mov x0,x22
    bl waitKey
    cmp x0,0
    beq 3b
    bl readKey
    cmp x0,#-1
    beq 99f                          // error
    bl keyMove
    cmp x0,#0
    beq 3b                            // no change -> loop
    cmp x0,#2                         // last addition = 2048 ?
    beq 4f
    cmp x0,#-1                        // quit ?
    bne 2b                            // loop

    b 10f
4:                                    // last addition = 2048
    ldr x0,qAdrszMessOK
    bl affichageMess
    b 10f
5:                                    // display message no solution
    ldr x0,qAdrszMessNotOK
    bl affichageMess

10:                                   // display new game ?
    ldr x0,qAdrszCarriageReturn
    bl affichageMess
    ldr x0,qAdrszMessNewGame
    bl affichageMess
11:
    mov x0,x22
    bl waitKey
    cmp x0,0
    beq 11b
    bl readKey
    ldr x0,qAdrqTouche
    ldrb w0,[x0]
    cmp w0,#'y'
    beq 1b
    cmp w0,#'Y'
    beq 1b
99:
    bl restauTerm                     // terminal restaur
100:                                  // standard end of the program
    mov x0, #0                        // return code
    mov x8, #EXIT                     // request to exit program
    svc #0                            // perform the system call

qAdrszCarriageReturn:     .quad szCarriageReturn
qAdrszMessNotOK:          .quad szMessNotOK
qAdrszMessOK:             .quad szMessOK
qAdrszMessNewGame:        .quad szMessNewGame
qAdrsZoneConv:            .quad sZoneConv
qAdrszCleax1:             .quad szCleax1
qAdrszMessErrInitTerm:    .quad szMessErrInitTerm
qAdrszMessErrInitPoll:    .quad szMessErrInitPoll
qAdrszMessErreurKey:      .quad szMessErreurKey
qAdrstOldtio:             .quad stOldtio
qAdrstCurtio:             .quad stCurtio
qAdrstSigAction:          .quad stSigAction
qAdrstSigAction1:         .quad stSigAction1
qAdrSIG_IGN:              .quad 1
qAdrqEnd:                 .quad qEnd
qAdrqTouche:              .quad qTouche
qAdrstevents:             .quad stevents
/******************************************************************/
/*     raz table cases                                                   */
/******************************************************************/
razTable:
    stp x0,lr,[sp,-16]!     // save  registres
    stp x1,x2,[sp,-16]!     // save  registres
    ldr x1,qAdrqTbCase
    mov x2,#0
1:
    str xzr,[x1,x2,lsl #3]
    add x2,x2,#1
    cmp x2,#SIZE * SIZE
    blt 1b
100:
    ldp x1,x2,[sp],16       // restaur des  2 registres
    ldp x0,lr,[sp],16       // restaur des  2 registres
    ret
/******************************************************************/
/*     key move                                                   */
/******************************************************************/
/* x0 contains key value               */
keyMove:
    stp x1,lr,[sp,-16]!     // save  registres
    lsr x0,x0,#16
    cmp x0,#0x42                  // down arrow
    bne 1f
    bl moveDown
    b 100f
1:
    cmp x0,#0x41                  // high arrow
    bne 2f
    bl moveUp
    b 100f
2:
    cmp x0,#0x43                  // right arrow
    bne 3f
    bl moveRight
    b 100f
3:
    cmp x0,#0x44                  // left arrow
    bne 4f
    bl moveLeft
    b 100f
4:
    ldr x0,qAdrqTouche
    ldrb w0,[x0]
    cmp w0,#'q'                   // quit game
    bne 5f
    mov x0,#-1
    b 100f
5:
    cmp w0,#'Q'                   // quit game
    bne 100f
    mov x0,#-1
    b 100f

100:
    ldp x1,lr,[sp],16       // restaur des  2 registres
    ret
/******************************************************************/
/*           move left                                   */
/******************************************************************/
/* x0 return -1 if ok     */
moveLeft:
    stp x1,lr,[sp,-16]!          // save  registres
    stp x2,x3,[sp,-16]!          // save  registres
    stp x4,x5,[sp,-16]!          // save  registres
    stp x6,x7,[sp,-16]!          // save  registres
    stp x8,x9,[sp,-16]!          // save  registres
    stp x10,x11,[sp,-16]!        // save  registres
    ldr x1,qAdrqTbCase
    mov x0,#0                   // top move Ok
    mov x2,#0                   // line indice
1:
    mov x6,#0                   // counter empty case
    mov x7,#0                   // first digit
    mov x10,#0                  // last digit to add
    mov x3,#0                   // column indice
2:
    lsl x5,x2,#2                // change this if size <> 4
    add x5,x5,x3                // compute table indice
    ldr x4,[x1,x5,lsl #3]
    cmp x4,#0
    cinc x6,x6,eq               // positions vides
    beq 5f
    cmp x6,#0
    beq 3f                      // no empty left case
    mov x8,#0
    str x8,[x1,x5,lsl #3]       // raz digit
    sub x5,x5,x6
    str x4,[x1,x5,lsl #3]       // and store to left empty position
    mov x0,#1                   // move Ok
3:
    cmp x7,#0                   // first digit
    beq 4f
    cmp x10,x4                  // prec digit have to add
    beq 4f
    sub x8,x5,#1                // prec digit
    ldr x9,[x1,x8,lsl #3]
    cmp x4,x9                   // equal ?
    bne 4f
    mov x10,x4                  // save digit
    add x4,x4,x9                // yes -> add
    str x4,[x1,x8,lsl #3]
    cmp x4,#TOTAL
    beq 6f
    mov x4,#0
    str x4,[x1,x5,lsl #3]
    add x6,x6,#1                // empty case + 1
    mov x0,#1                   // move Ok
4:
    add x7,x7,#1                // no first digit

5:                              // and loop
    add x3,x3,#1
    cmp x3,#SIZE
    blt 2b
    add x2,x2,#1
    cmp x2,#SIZE
    blt 1b
    b 100f
6:
    mov x0,#2                   // total = 2048
100:
    ldp x10,x11,[sp],16         // restaur des  2 registres
    ldp x8,x9,[sp],16           // restaur des  2 registres
    ldp x6,x7,[sp],16           // restaur des  2 registres
    ldp x4,x5,[sp],16           // restaur des  2 registres
    ldp x2,x3,[sp],16           // restaur des  2 registres
    ldp x1,lr,[sp],16           // restaur des  2 registres
    ret
/******************************************************************/
/*           move right                                   */
/******************************************************************/
/* x0 return -1 if ok     */
moveRight:
    stp x1,lr,[sp,-16]!          // save  registres
    stp x2,x3,[sp,-16]!          // save  registres
    stp x4,x5,[sp,-16]!          // save  registres
    stp x6,x7,[sp,-16]!          // save  registres
    stp x8,x9,[sp,-16]!          // save  registres
    stp x10,x11,[sp,-16]!        // save  registres
    ldr x1,qAdrqTbCase
    mov x0,#0
    mov x2,#0
1:
    mov x6,#0
    mov x7,#0
    mov x10,#0
    mov x3,#SIZE-1
2:
    lsl x5,x2,#2                  // change this if size <> 4
    add x5,x5,x3
    ldr x4,[x1,x5,lsl #3]
    cmp x4,#0
    cinc x6,x6,eq               // positions vides
    beq 5f

    cmp x6,#0
    beq 3f                      // no empty right case
    mov x0,#0
    str x0,[x1,x5,lsl #3]       // raz digit
    add x5,x5,x6
    str x4,[x1,x5,lsl #3]       // and store to right empty position
    mov x0,#1
3:
    cmp x7,#0                   // first digit
    beq 4f
    add x8,x5,#1                // next digit
    ldr x9,[x1,x8,lsl #3]
    cmp x4,x9                   // equal ?
    bne 4f
    cmp x10,x4
    beq 4f
    mov x10,x4
    add x4,x4,x9                // yes -> add
    str x4,[x1,x8,lsl #3]
    cmp x4,#TOTAL
    beq 6f
    mov x4,#0
    str x4,[x1,x5,lsl #3]
    add x6,x6,#1                // empty case + 1
    mov x0,#1
4:
    add x7,x7,#1                // no first digit

5:                              // and loop
    sub x3,x3,#1
    cmp x3,#0
    bge 2b
    add x2,x2,#1
    cmp x2,#SIZE
    blt 1b
    b 100f
6:
    mov x0,#2
100:
    ldp x10,x11,[sp],16         // restaur des  2 registres
    ldp x8,x9,[sp],16           // restaur des  2 registres
    ldp x6,x7,[sp],16           // restaur des  2 registres
    ldp x4,x5,[sp],16           // restaur des  2 registres
    ldp x2,x3,[sp],16           // restaur des  2 registres
    ldp x1,lr,[sp],16           // restaur des  2 registres
    ret
/******************************************************************/
/*           move down                                   */
/******************************************************************/
/* x0 return -1 if ok     */
moveDown:
    stp x1,lr,[sp,-16]!          // save  registres
    stp x2,x3,[sp,-16]!          // save  registres
    stp x4,x5,[sp,-16]!          // save  registres
    stp x6,x7,[sp,-16]!          // save  registres
    stp x8,x9,[sp,-16]!          // save  registres
    stp x10,x11,[sp,-16]!        // save  registres
    ldr x1,qAdrqTbCase
    mov x0,#0
    mov x3,#0
1:
    mov x6,#0
    mov x7,#0
    mov x10,#0
    mov x2,#SIZE-1
2:
    lsl x5,x2,#2                  // change this if size <> 4
    add x5,x5,x3
    ldr x4,[x1,x5,lsl #3]
    cmp x4,#0
    cinc x6,x6,eq               // positions vides
    beq 5f
    cmp x6,#0
    beq 3f                      // no empty right case
    mov x0,#0
    str x0,[x1,x5,lsl #3]       // raz digit
    lsl x0,x6,#2
    add x5,x5,x0
    str x4,[x1,x5,lsl #3]       // and store to right empty position
    mov x0,#1
3:
    cmp x7,#0                   // first digit
    beq 4f
    add x8,x5,#SIZE                // down digit
    ldr x9,[x1,x8,lsl #3]
    cmp x4,x9                   // equal ?
    bne 4f
    cmp x10,x4
    beq 4f
    mov x10,x4
    add x4,x4,x9                // yes -> add
    str x4,[x1,x8,lsl #3]
    cmp x4,#TOTAL
    beq 6f
    mov x4,#0
    str x4,[x1,x5,lsl #3]
    add x6,x6,#1                // empty case + 1
    mov x0,#1
4:
    add x7,x7,#1                   // no first digit

5:                           // and loop
    sub x2,x2,#1
    cmp x2,#0
    bge 2b
    add x3,x3,#1
    cmp x3,#SIZE
    blt 1b
    b 100f
6:
    mov x0,#2
100:
    ldp x10,x11,[sp],16         // restaur des  2 registres
    ldp x8,x9,[sp],16           // restaur des  2 registres
    ldp x6,x7,[sp],16           // restaur des  2 registres
    ldp x4,x5,[sp],16           // restaur des  2 registres
    ldp x2,x3,[sp],16           // restaur des  2 registres
    ldp x1,lr,[sp],16           // restaur des  2 registres
    ret
/******************************************************************/
/*           move up                                   */
/******************************************************************/
/* x0 return -1 if ok     */
moveUp:
    stp x1,lr,[sp,-16]!          // save  registres
    stp x2,x3,[sp,-16]!          // save  registres
    stp x4,x5,[sp,-16]!          // save  registres
    stp x6,x7,[sp,-16]!          // save  registres
    stp x8,x9,[sp,-16]!          // save  registres
    stp x10,x11,[sp,-16]!        // save  registres
    ldr x1,qAdrqTbCase
    mov x0,#0
    mov x3,#0
1:
    mov x6,#0
    mov x7,#0
    mov x10,#0
    mov x2,#0
2:
    lsl x5,x2,#2                  // change this if size <> 4
    add x5,x5,x3
    ldr x4,[x1,x5,lsl #3]
    cmp x4,#0
    cinc x6,x6,eq               // positions vides
    beq 5f
    cmp x6,#0
    beq 3f                      // no empty right case
    mov x0,#0
    str x0,[x1,x5,lsl #3]       // raz digit
    lsl x0,x6,#2
    sub x5,x5,x0
    str x4,[x1,x5,lsl #3]       // and store to right empty position
    mov x0,#1
3:
    cmp x7,#0                   // first digit
    beq 4f
    sub x8,x5,#SIZE             // up digit
    ldr x9,[x1,x8,lsl #3]
    cmp x4,x9                   // equal ?
    bne 4f
    cmp x10,x4
    beq 4f
    mov x10,x4
    add x4,x4,x9                // yes -> add
    str x4,[x1,x8,lsl #3]
    cmp x4,#TOTAL
    beq 6f
    mov x4,#0
    str x4,[x1,x5,lsl #3]
    add x6,x6,#1                // empty case + 1
    mov x0,#1
4:
    add x7,x7,#1                // no first digit

5:                              // and loop
    add x2,x2,#1
    cmp x2,#SIZE
    blt 2b
    add x3,x3,#1
    cmp x3,#SIZE
    blt 1b
    b 100f
6:
    mov x0,#2
100:
    ldp x10,x11,[sp],16         // restaur des  2 registres
    ldp x8,x9,[sp],16           // restaur des  2 registres
    ldp x6,x7,[sp],16           // restaur des  2 registres
    ldp x4,x5,[sp],16           // restaur des  2 registres
    ldp x2,x3,[sp],16           // restaur des  2 registres
    ldp x1,lr,[sp],16           // restaur des  2 registres
    ret
/******************************************************************/
/*           add new digit on game                                   */
/******************************************************************/
/* x0 return -1 if ok     */
addDigit:
    stp x1,lr,[sp,-16]!          // save  registres
    stp x2,x3,[sp,-16]!          // save  registres
    stp x4,x5,[sp,-16]!          // save  registres
    sub sp,sp,#8 * SIZE*SIZE
    mov fp,sp

    mov x0,#100
    bl genereraleas
    cmp x0,#10
    mov x1,#4
    mov x5,#2
    csel x5,x5,x1,ge
   // movlt x5,#4
    //movge x5,#2
    ldr x1,qAdrqTbCase
    mov x3,#0
    mov x4,#0
1:
    ldr x2,[x1,x3,lsl 3]
    cmp x2,#0
    bne 2f
    str x3,[fp,x4,lsl 3]
    add x4,x4,#1
2:
    add x3,x3,#1
    cmp x3,#SIZE*SIZE
    blt 1b
    cmp x4,#0                 // no empty case
    beq 4f
    cmp x4,#1
    bne 3f
    ldr x2,[fp]               // one case
    str x5,[x1,x2,lsl 3]
    mov x0,#0
    b 100f
3:                            // multiple case
    sub x0,x4,#1
    bl genereraleas
    ldr x2,[fp,x0,lsl 3]
    str x5,[x1,x2,lsl 3]
    mov x0,#0
    b 100f
4:
    mov x0,#-1
100:
    add sp,sp,#8*  (SIZE*SIZE)  // stack alignement
    ldp x4,x5,[sp],16           // restaur des  2 registres
    ldp x2,x3,[sp],16           // restaur des  2 registres
    ldp x1,lr,[sp],16           // restaur des  2 registres
    ret
qAdrqTbCase:         .quad qTbCase
/******************************************************************/
/*            display game                                      */
/******************************************************************/
displayGame:
    stp x1,lr,[sp,-16]!          // save  registres
    stp x2,x3,[sp,-16]!          // save  registres
    ldr x0,qAdrszCleax1
    bl affichageMess
    ldr x0,qAdrszLineH
    bl affichageMess
    ldr x0,qAdrszLineVT
    bl affichageMess
    ldr x0,qAdrszLineV
    bl affichageMess
    ldr x1,qAdrqTbCase
    mov x2,#0
1:
    ldr x0,[x1,x2,lsl #3]
    bl digitString
    bl affichageMess
    ldr x0,qAdrszLineV
    bl affichageMess
    add x2,x2,#1
    cmp x2,#SIZE
    blt 1b
    ldr x0,qAdrszCarriageReturn
    bl affichageMess
    ldr x0,qAdrszLineVT
    bl affichageMess
    ldr x0,qAdrszLineH
    bl affichageMess
    ldr x0,qAdrszLineVT
    bl affichageMess
    ldr x0,qAdrszLineV
    bl affichageMess
2:
    ldr x0,[x1,x2,lsl #3]
    bl digitString
    bl affichageMess
    ldr x0,qAdrszLineV
    bl affichageMess
    add x2,x2,#1
    cmp x2,#SIZE*2
    blt 2b
    ldr x0,qAdrszCarriageReturn
    bl affichageMess
    ldr x0,qAdrszLineVT
    bl affichageMess
    ldr x0,qAdrszLineH
    bl affichageMess
    ldr x0,qAdrszLineVT
    bl affichageMess
    ldr x0,qAdrszLineV
    bl affichageMess
3:
    ldr x0,[x1,x2,lsl #3]
    bl digitString
    bl affichageMess
    ldr x0,qAdrszLineV
    bl affichageMess
    add x2,x2,#1
    cmp x2,#SIZE*3
    blt 3b
    ldr x0,qAdrszCarriageReturn
    bl affichageMess
    ldr x0,qAdrszLineVT
    bl affichageMess
    ldr x0,qAdrszLineH
    bl affichageMess
    ldr x0,qAdrszLineVT
    bl affichageMess
    ldr x0,qAdrszLineV
    bl affichageMess
4:
    ldr x0,[x1,x2,lsl #3]
    bl digitString
    bl affichageMess
    ldr x0,qAdrszLineV
    bl affichageMess
    add x2,x2,#1
    cmp x2,#SIZE*4
    blt 4b
    ldr x0,qAdrszCarriageReturn
    bl affichageMess
    ldr x0,qAdrszLineVT
    bl affichageMess
    ldr x0,qAdrszLineH
    bl affichageMess

100:
    ldp x2,x3,[sp],16           // restaur des  2 registres
    ldp x1,lr,[sp],16           // restaur des  2 registres
    ret
qAdrszLineH:         .quad szLineH
qAdrszLineV:         .quad szLineV
qAdrszLineVT:        .quad szLineVT
/******************************************************************/
/*            digits string                                       */
/******************************************************************/
/* x0 contains number */
/* x0 return address string */
digitString:
    stp x1,lr,[sp,-16]!          // save  registres
    cmp x0,#0
    bne 1f
    ldr x0,qAdrszMess0
    b 100f
1:
    cmp x0,#2
    bne 2f
    ldr x0,qAdrszMess2
    b 100f
2:
    cmp x0,#4
    bne 3f
    ldr x0,qAdrszMess4
    b 100f
3:
    cmp x0,#8
    bne 4f
    ldr x0,qAdrszMess8
    b 100f
4:
    cmp x0,#16
    bne 5f
    ldr x0,qAdrszMess16
    b 100f
5:
    cmp x0,#32
    bne 6f
    ldr x0,qAdrszMess32
    b 100f
6:
    cmp x0,#64
    bne 7f
    ldr x0,qAdrszMess64
    b 100f
7:
    cmp x0,#128
    bne 8f
    ldr x0,qAdrszMess128
    b 100f
8:
    cmp x0,#256
    bne 9f
    ldr x0,qAdrszMess256
    b 100f
9:
    cmp x0,#512
    bne 10f
    ldr x0,qAdrszMess512
    b 100f
10:
    cmp x0,#1024
    bne 11f
    ldr x0,qAdrszMess1024
    b 100f
11:
    cmp x0,#2048
    bne 12f
    ldr x0,qAdrszMess2048
    b 100f
12:
    ldr x1,qAdrszMessErreur                       // error message
    bl   displayError
100:
    ldp x1,lr,[sp],16           // restaur des  2 registres
    ret
qAdrszMess0:          .quad szMess0
qAdrszMess2:          .quad szMess2
qAdrszMess4:          .quad szMess4
qAdrszMess8:          .quad szMess8
qAdrszMess16:         .quad szMess16
qAdrszMess32:         .quad szMess32
qAdrszMess64:         .quad szMess64
qAdrszMess128:        .quad szMess128
qAdrszMess256:        .quad szMess256
qAdrszMess512:        .quad szMess512
qAdrszMess1024:       .quad szMess1024
qAdrszMess2048:        .quad szMess2048

//qAdrsBuffer:         .quad sBuffer
qAdrszMessErreur :        .quad szMessErreur

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
/*****************************************************/
qAdrqGraine: .quad qGraine
qNbDep1:     .quad 0x0019660d
qNbDep2:     .quad 0x3c6ef35f

/******************************************************************/
/*     traitement du signal                                       */
/******************************************************************/
sighandler:
    stp x0,lr,[sp,-16]!            // save  registers
    str x1,[sp,-16]!
    ldr x0,qAdrqEnd
    mov x1,#1                      // maj zone end
    str x1,[x0]
    ldr x1,[sp],16
    ldp x0,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30
/***************************************************/
/*   display error message                         */
/***************************************************/
/* x0 contains error code  x1 : message address */
displayError:
    stp x2,lr,[sp,-16]!            // save  registers
    mov x2,x0                      // save error code
    mov x0,x1
    bl affichageMess
    mov x0,x2                      // error code
    ldr x1,qAdrsZoneConv
    bl conversion16                // conversion hexa
    ldr x0,qAdrszMessErr           // display error message
    ldr x1,qAdrsZoneConv
    bl strInsertAtCharInc               // insert result at @ character
    mov x3,x0
    mov x0,x2                      // error code
    ldr x1,qAdrsZoneConv               // result address
    bl conversion10S                // conversion decimale
    mov x0,x3
    ldr x1,qAdrsZoneConv
    bl strInsertAtCharInc               // insert result at @ character
    bl affichageMess
100:
    ldp x2,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30
qAdrszMessErr:                 .quad szMessErr
/*********************************/
/* init terminal state            */
/*********************************/
initTerm:
    stp x1,lr,[sp,-16]!            // save  registers
    /* read terminal state */
    mov x0,STDIN                   // input console
    mov x1,TCGETS
    ldr x2,qAdrstOldtio
    mov x8,IOCTL                   // call system Linux
    svc 0
    cbnz x0,98f                    // error ?

    adr x0,sighandler              // adresse routine traitement signal
    ldr x1,qAdrstSigAction         // adresse structure sigaction
    str x0,[x1,sa_handler]         // maj handler
    mov x0,SIGINT                  // signal type
    ldr x1,qAdrstSigAction
    mov x2,0
    mov x3,8
    mov x8,SIGACTION               // call system
    svc 0

    cmp x0,0                       // error ?
    bne 98f
    mov x0,SIGQUIT
    ldr x1,qAdrstSigAction
    mov x2,0                       // NULL
    mov x8,SIGACTION               // call system
    svc 0
    cmp x0,0                       // error ?
    bne 98f
    mov x0,SIGTERM
    ldr x1,qAdrstSigAction
    mov x2,0                       // NULL
    mov x8,SIGACTION               // appel systeme
    svc 0
    cmp x0,0
    bne 98f
    //
    adr x0,qAdrSIG_IGN             // address signal igonre function
    ldr x1,qAdrstSigAction1
    str x0,[x1,sa_handler]
    mov x0,SIGTTOU                 //invalidate other process signal
    ldr x1,qAdrstSigAction1
    mov x2,0                       // NULL
    mov x8,SIGACTION               // call system
    svc 0
    cmp x0,0
    bne 98f
    //
    /* read terminal current state  */
    mov x0,STDIN
    mov x1,TCGETS
    ldr x2,qAdrstCurtio            // address current termio
    mov x8,IOCTL                   // call systeme
    svc 0
    cmp x0,0                       // error ?
    bne 98f
    mov x2,ICANON | ECHO           // no key pressed echo on display
    mvn x2,x2                      // and one key
    ldr x1,qAdrstCurtio
    ldr x3,[x1,#term_c_lflag]
    and x3,x2,x2                   // add flags
    str x3,[x1,#term_c_lflag]      // and store
    mov x0,STDIN                   // maj terminal current state
    mov x1,TCSETS
    ldr x2,qAdrstCurtio
    mov x8,IOCTL                   // call system
    svc 0
    cbz x0,100f
98:                                // error display
    ldr x1,qAdrszMessErrInitTerm
    bl   displayError
    mov x0,-1
100:
    ldp x1,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30
qAdrstSigAction2:    .quad stSigAction2
qAdrstSigAction3:    .quad stSigAction3
/*********************************/
/* init instance epool            */
/*********************************/
initPoll:
    stp x1,lr,[sp,-16]!            // save  registers
    ldr x0,qAdrstevents
    mov x1,STDIN                   // maj structure events
    str x1,[x0,#poll_fd]           // maj FD
    mov x1,POLLIN                  // action code
    str x1,[x0,#poll_event]
    mov x0,0
    mov x8,CREATPOLL               // create epoll instance
    svc 0
    cmp x0,0                       // error ?
    ble 98f
    mov x10,x0                     // return FD epoll instance
    mov x1,EPOLL_CTL_ADD
    mov x2,STDIN                   // Fd to we want add
    ldr x3,qAdrstevents            // structure events address
    mov x8,CTLPOLL                 // call system control epoll
    svc 0
    cmp x0,0                       // error ?
    blt 98f                       // no
    mov x0,x10                     // return FD epoll instance
    b 100f
98:                                // error display
    ldr x1,qAdrszMessErrInitPoll   // error message
    bl   displayError
    mov x0,-1
100:
    ldp x1,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30
/*********************************/
/* wait key                      */
/*********************************/
/* x0 contains FD poll    */
waitKey:
    stp x1,lr,[sp,-16]!            // save  registers
    ldr x11,qAdrqTouche            // key address
    str xzr,[x11]                  // raz key
1:
    ldr x1,qAdrqEnd                // if signal ctrl-c  -> end
    ldr x1,[x1]
    cbnz x1,100f

    ldr x1,qAdrstevents
    mov x2,12                      // size events
    mov x3,1                       // timeout = 1  TODO: ??
    mov x4,0
    mov x8,SYSPOLL                 // call system wait POLL
    svc 0
    cmp x0,0                       // key pressed ?
    bge 100f
98:                                // error display
    ldr x1,qAdrszMessErreurKey        // error message
    bl   displayError
    mov x0,-1
100:
    ldp x1,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30
/*********************************/
/* read key                      */
/*********************************/
/* x0 returns key value */
readKey:
    stp x1,lr,[sp,-16]!            // save  registers
    mov x0,STDIN                   // File Descriptor
    ldr x1,qAdrqTouche             // buffer address
    mov x2,KEYSIZE                 // key size
    mov x8,READ                    // read key
    svc #0
    cmp x0,0                       // error ?
    ble 98f
    ldr x2,qAdrqTouche             // key address
    ldr x0,[x2]
    b 100f
98:                                // error display
    ldr x1,qAdrszMessErreur        // error message
    bl   displayError
    mov x0,-1
100:
    ldp x1,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30
/*********************************/
/* restaur terminal state        */
/*********************************/
restauTerm:
    stp x1,lr,[sp,-16]!            // save  registers
    mov x0,STDIN                   // end then restaur begin state terminal
    mov x1,TCSETS
    ldr x2,qAdrstOldtio
    mov x8,IOCTL                   // call system
    svc 0
    cbz x0,100f
    ldr x1,qAdrszMessErreur        // error message
    bl   displayError
100:
    ldp x1,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30
/********************************************************/
/*        File Include fonctions                        */
/********************************************************/
/* for this file see task include a file in language AArch64 assembly */
.include "../includeARM64.inc"
