/* ARM assembly AARCH64 Raspberry PI 3B */
/*  program Ycombi64.s   */

/*******************************************/
/* Constantes file                         */
/*******************************************/
/* for this file see task include a file in language AArch64 assembly*/
.include "../includeConstantesARM64.inc"

/*******************************************/
/* Structures                               */
/********************************************/
/* structure function*/
    .struct  0
func_fn:                    // next element
    .struct  func_fn + 8
func_f_:                    // next element
    .struct  func_f_ + 8
func_num:
    .struct  func_num + 8
func_fin:

/* Initialized data */
.data
szMessStartPgm:            .asciz "Program start \n"
szMessEndPgm:              .asciz "Program normal end.\n"
szMessError:               .asciz "\033[31mError Allocation !!!\n"

szFactorielle:             .asciz "Function factorielle : \n"
szFibonacci:               .asciz "Function Fibonacci : \n"
szCarriageReturn:          .asciz "\n"

/* datas message display */
szMessResult:            .ascii "Result value : @ \n"

/* UnInitialized data */
.bss
sZoneConv:                .skip 100
/*  code section */
.text
.global main
main:                                           // program start
    ldr x0,qAdrszMessStartPgm                   // display start message
    bl affichageMess
    adr x0,facFunc                              // function factorielle address
    bl YFunc                                    // create Ycombinator
    mov x19,x0                                   // save Ycombinator
    ldr x0,qAdrszFactorielle                    // display message
    bl affichageMess
    mov x20,#1                                   // loop counter
1:  // start loop
    mov x0,x20
    bl numFunc                                  // create number structure
    cmp x0,#-1                                  // allocation error ?
    beq 99f
    mov x1,x0                                   // structure number address
    mov x0,x19                                  // Ycombinator address
    bl callFunc                                 // call
    ldr x0,[x0,#func_num]                       // load result
    ldr x1,qAdrsZoneConv                        // and convert ascii string
    bl conversion10S                            // decimal conversion
    ldr x0,qAdrszMessResult
    ldr x1,qAdrsZoneConv
    bl strInsertAtCharInc                       // insert result at @ character
    bl affichageMess                            // display message final

    add x20,x20,#1                              // increment loop counter
    cmp x20,#10                                 // end ?
    ble 1b                                      // no -> loop
/*********Fibonacci  *************/
    adr x0,fibFunc                              // function fibonacci address
    bl YFunc                                    // create Ycombinator
    mov x19,x0                                  // save Ycombinator
    ldr x0,qAdrszFibonacci                      // display message
    bl affichageMess
    mov x20,#1                                  // loop counter
2:  // start loop
    mov x0,x20
    bl numFunc                                  // create number structure
    cmp x0,#-1                                  // allocation error ?
    beq 99f
    mov x1,x0                                   // structure number address
    mov x0,x19                                   // Ycombinator address
    bl callFunc                                 // call
    ldr x0,[x0,#func_num]                       // load result
    ldr x1,qAdrsZoneConv                        // and convert ascii string
    bl conversion10S
    ldr x0,qAdrszMessResult
    ldr x1,qAdrsZoneConv
    bl strInsertAtCharInc                       // insert result at @ character
    bl affichageMess
    add x20,x20,#1                                   // increment loop counter
    cmp x20,#10                                  // end ?
    ble 2b                                      // no -> loop
    ldr x0,qAdrszMessEndPgm                     // display end message
    bl affichageMess
    b 100f
99:                                             // display error message
    ldr x0,qAdrszMessError
    bl affichageMess
100:                                            // standard end of the program
    mov x0,0                                    // return code
    mov x8,EXIT                                 // request to exit program
    svc 0                                       // perform system call
qAdrszMessStartPgm:        .quad szMessStartPgm
qAdrszMessEndPgm:          .quad szMessEndPgm
qAdrszFactorielle:         .quad szFactorielle
qAdrszFibonacci:           .quad szFibonacci
qAdrszMessError:           .quad szMessError
qAdrszCarriageReturn:      .quad szCarriageReturn
qAdrszMessResult:          .quad szMessResult
qAdrsZoneConv:             .quad sZoneConv
/******************************************************************/
/*     factorielle function                         */
/******************************************************************/
/* x0 contains the Y combinator address  */
/* x1 contains the number structure  */
facFunc:
    stp x1,lr,[sp,-16]!            // save  registers
    stp x2,x3,[sp,-16]!            // save  registers
    mov x2,x0                   // save Y combinator address
    ldr x0,[x1,#func_num]       // load number
    cmp x0,#1                   // > 1 ?
    bgt 1f                      // yes
    mov x0,#1                   // create structure number value 1
    bl numFunc
    b 100f
1:
    mov x3,x0                   // save number
    sub x0,x0,#1                   // decrement number
    bl numFunc                  // and create new structure number
    cmp x0,#-1                  // allocation error ?
    beq 100f
    mov x1,x0                   // new structure number -> param 1
    ldr x0,[x2,#func_f_]        // load function address to execute
    bl callFunc                 // call
    ldr x1,[x0,#func_num]       // load new result
    mul x0,x1,x3                // and multiply by precedent
    bl numFunc                  // and create new structure number
                                // and return her address in x0
100:
    ldp x2,x3,[sp],16              // restaur  2 registers
    ldp x1,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30
/******************************************************************/
/*     fibonacci function                         */
/******************************************************************/
/* x0 contains the Y combinator address  */
/* x1 contains the number structure  */
fibFunc:
    stp x1,lr,[sp,-16]!            // save  registers
    stp x2,x3,[sp,-16]!            // save  registers
    stp x4,x5,[sp,-16]!            // save  registers
    mov x2,x0                   // save Y combinator address
    ldr x0,[x1,#func_num]       // load number
    cmp x0,#1                   // > 1 ?
    bgt 1f                      // yes
    mov x0,#1                   // create structure number value 1
    bl numFunc
    b 100f
1:
    mov x3,x0                   // save number
    sub x0,x0,#1                // decrement number
    bl numFunc                  // and create new structure number
    cmp x0,#-1                  // allocation error ?
    beq 100f
    mov x1,x0                   // new structure number -> param 1
    ldr x0,[x2,#func_f_]        // load function address to execute
    bl callFunc                 // call
    ldr x4,[x0,#func_num]       // load new result
    sub x0,x3,#2                // new number - 2
    bl numFunc                  // and create new structure number
    cmp x0,#-1                  // allocation error ?
    beq 100f
    mov x1,x0                   // new structure number -> param 1
    ldr x0,[x2,#func_f_]        // load function address to execute
    bl callFunc                 // call
    ldr x1,[x0,#func_num]       // load new result
    add x0,x1,x4                // add two results
    bl numFunc                  // and create new structure number
                                // and return her address in x0
100:
    ldp x4,x5,[sp],16              // restaur  2 registers
    ldp x2,x3,[sp],16              // restaur  2 registers
    ldp x1,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30
/******************************************************************/
/*     call function                         */
/******************************************************************/
/* x0 contains the address of the function  */
/* x1 contains the address of the function 1 */
callFunc:
    stp x2,lr,[sp,-16]!            // save  registers
    ldr x2,[x0,#func_fn]           // load function address to execute
    blr x2                         // and call it
    ldp x2,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30
/******************************************************************/
/*     create Y combinator function                         */
/******************************************************************/
/* x0 contains the address of the function  */
YFunc:
    stp x1,lr,[sp,-16]!            // save  registers
    mov x1,#0
    bl newFunc
    cmp x0,#-1                     // allocation error ?
    beq 100f
    str x0,[x0,#func_f_]           // store function and return in x0
100:
    ldp x1,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30
/******************************************************************/
/*     create structure number function                         */
/******************************************************************/
/* x0 contains the number  */
numFunc:
    stp x1,lr,[sp,-16]!            // save  registers
    stp x2,x3,[sp,-16]!            // save  registers
    mov x2,x0                      // save number
    mov x0,#0                      // function null
    mov x1,#0                      // function null
    bl newFunc
    cmp x0,#-1                     // allocation error ?
    beq 100f
    str x2,[x0,#func_num]          // store number in new structure
100:
    ldp x2,x3,[sp],16              // restaur  2 registers
    ldp x1,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30
/******************************************************************/
/*     new function                                               */
/******************************************************************/
/* x0 contains the function address   */
/* x1 contains the function address 1   */
newFunc:
    stp x1,lr,[sp,-16]!            // save  registers
    stp x3,x4,[sp,-16]!            // save  registers
    stp x5,x8,[sp,-16]!            // save  registers
    mov x4,x0                      // save address
    mov x5,x1                      // save adresse 1
                                   // allocation place on the heap
    mov x0,#0                      // allocation place heap
    mov x8,BRK                     // call system 'brk'
    svc #0
    mov x6,x0                      // save address heap for output string
    add x0,x0,#func_fin            // reservation place one element
    mov x8,BRK                     // call system 'brk'
    svc #0
    cmp x0,#-1                     // allocation error
    beq 100f
    mov x0,x6
    str x4,[x0,#func_fn]           // store address
    str x5,[x0,#func_f_]
    str xzr,[x0,#func_num]         // store zero to number
100:
    ldp x5,x8,[sp],16              // restaur  2 registers
    ldp x3,x4,[sp],16              // restaur  2 registers
    ldp x1,lr,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30
/********************************************************/
/*        File Include fonctions                        */
/********************************************************/
/* for this file see task include a file in language AArch64 assembly */
.include "../includeARM64.inc"
