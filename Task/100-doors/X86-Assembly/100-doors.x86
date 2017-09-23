; linux x86_64

section .data
open: db "open", 10
closed: db "closed", 10

section .bss
doors resb 101

section .text

global _start

_start:
mov rax, 1
  mov bl, 0
  zeroset_door:
    mov [doors + rax], bl
    inc rax
    cmp rax, 101
    jl zeroset_door

  mov rax, 0
  set_doors:
    inc rax
    cmp rax, 101
    je display_result
    mov rbx, 0

    make_pass:
      add rbx, rax
      cmp rbx, 101
      jge set_doors
      not byte [doors + rbx]
      jmp make_pass

  display_result:
    mov rbx, 0
    display_door:
      inc rbx
      cmp rbx, 101
      je exit
      cmp byte [doors + rbx], 0
      je print_closed
      jmp print_open

  print_open:
    mov rax, 1
    mov rdi, 1
    mov rsi, open
    mov rdx, 5
    syscall
    jmp display_door

  print_closed:
    mov rax, 1
    mov rdi, 1
    mov rsi, closed
    mov rdx, 7
    syscall
    jmp display_door

  exit:
    mov rax, 60
    mov rdi, 0
    syscall
