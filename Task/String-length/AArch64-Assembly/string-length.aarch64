/* ARM assembly AARCH64 Raspberry PI 3B */
/*  program stringLength64.s   */

/*******************************************/
/* Constantes file                         */
/*******************************************/
/* for this file see task include a file in language AArch64 assembly*/
.include "../includeConstantesARM64.inc"

/*********************************/
/* Initialized data              */
/*********************************/
.data
sMessResultByte:        .asciz "===Byte Length=== : @ \n"
sMessResultChar:        .asciz "===Character Length=== : @ \n"
szString1:              .asciz "møøse€"
szCarriageReturn:       .asciz "\n"

/*********************************/
/* UnInitialized data            */
/*********************************/
.bss
sZoneConv:        .skip 24
/*********************************/
/*  code section                 */
/*********************************/
.text
.global main
main:                                 // entry of program
    ldr x0,qAdrszString1
    bl affichageMess                  // display string
    ldr x0,qAdrszCarriageReturn
    bl affichageMess

    ldr x0,qAdrszString1
    mov x1,#0
1:                                    // loop compute length bytes
    ldrb w2,[x0,x1]
    cmp w2,#0
    cinc x1,x1,ne
    bne 1b

    mov x0,x1                         // result display
    ldr x1,qAdrsZoneConv
    bl conversion10                   // call decimal conversion
    ldr x0,qAdrsMessResultByte
    ldr x1,qAdrsZoneConv              // insert conversion in message
    bl strInsertAtCharInc
    bl affichageMess

    ldr x0,qAdrszString1
    mov x1,#0
    mov x3,#0
2:                                    // loop compute length characters
    ldrb w2,[x0,x1]
    cmp w2,#0
    beq 6f
    and x2,x2,#0b11100000             // 3 bytes ?
    cmp x2,#0b11100000
    bne 3f
    add x3,x3,#1
    add x1,x1,#3
    b 2b
3:
    and x2,x2,#0b11000000              // 2 bytes ?
    cmp x2,#0b11000000
    bne 4f
    add x3,x3,#1
    add x1,x1,#2
    b 2b
4:                                    // else 1 byte
    add x3,x3,#1
    add x1,x1,#1
    b 2b

6:
    mov x0,x3
    ldr x1,qAdrsZoneConv
    bl conversion10                   // call decimal conversion
    ldr x0,qAdrsMessResultChar
    ldr x1,qAdrsZoneConv              // insert conversion in message
    bl strInsertAtCharInc
    bl affichageMess
100:                                  // standard end of the program
    mov x0,0                          // return code
    mov x8,EXIT                       // request to exit program
    svc 0                             // perform the system call

qAdrszCarriageReturn:     .quad szCarriageReturn
qAdrsMessResultByte:      .quad sMessResultByte
qAdrsMessResultChar:      .quad sMessResultChar
qAdrszString1:            .quad szString1
qAdrsZoneConv:            .quad sZoneConv
/********************************************************/
/*        File Include fonctions                        */
/********************************************************/
/* for this file see task include a file in language AArch64 assembly */
.include "../includeARM64.inc"
