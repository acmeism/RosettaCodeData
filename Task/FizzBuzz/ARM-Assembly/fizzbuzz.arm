/ * linux GAS */

.global _start

.data

Fizz: .ascii "Fizz\n"
Buzz: .ascii "Buzz\n"
FizzAndBuzz: .ascii "FizzBuzz\n"

numstr_buffer: .skip 3
newLine: .ascii "\n"

.text

_start:

  bl FizzBuzz

  mov r7, #1
  mov r0, #0
  svc #0

FizzBuzz:

  push {lr}
  mov r9, #100

  fizzbuzz_loop:

    mov r0, r9
    mov r1, #15
    bl divide
    cmp r1, #0
    ldreq r1, =FizzAndBuzz
    moveq r2, #9
    beq fizzbuzz_print

    mov r0, r9
    mov r1, #3
    bl divide
    cmp r1, #0
    ldreq r1, =Fizz
    moveq r2, #5
    beq fizzbuzz_print

    mov r0, r9
    mov r1, #5
    bl divide
    cmp r1, #0
    ldreq r1, =Buzz
    moveq r2, #5
    beq fizzbuzz_print

    mov r0, r9
    bl make_num
    mov r2, r1
    mov r1, r0

    fizzbuzz_print:

      mov r0, #1
      mov r7, #4
      svc #0

      sub r9, #1
      cmp r9, #0

    bgt fizzbuzz_loop

  pop {lr}
  mov pc, lr

make_num:

  push {lr}
  ldr r4, =numstr_buffer
  mov r5, #4
  mov r6, #1

  mov r1, #100
  bl divide

  cmp r0, #0
  subeq r5, #1
  movne r6, #0

  add r0, #48
  strb r0, [r4, #0]

  mov r0, r1
  mov r1, #10
  bl divide

  cmp r0, #0
  movne r6, #0
  cmp r6, #1
  subeq r5, #1

  add r0, #48
  strb r0, [r4, #1]

  add r1, #48
  strb r1, [r4, #2]

  mov r2, #4
  sub r0, r2, r5
  add r0, r4, r0
  mov r1, r5

  pop {lr}
  mov pc, lr

divide:
  udiv r2, r0, r1
  mul r3, r1, r2
  sub r1, r0, r3
  mov r0, r2
  mov pc, lr
