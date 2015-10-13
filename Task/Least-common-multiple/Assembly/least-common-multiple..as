; lcm.asm: calculates the least common multiple
; of two positive integers
;
; nasm x86_64 assembly (linux) with libc
; assemble: nasm -felf64 lcm.asm; gcc lcm.o
; usage: ./a.out [number1] [number2]

    global main
    extern printf ; c function: prints formatted output
    extern strtol ; c function: converts strings to longs

    section .text

main:
    push rbp    ; set up stack frame

    ; rdi contains argc
    ; if less than 3, exit
    cmp rdi, 3
    jl incorrect_usage

    ; push first argument as number
    push rsi
    mov rdi, [rsi+8]
    mov rsi, 0
    mov rdx, 10 ; base 10
    call strtol
    pop rsi
    push rax

    ; push second argument as number
    push rsi
    mov rdi, [rsi+16]
    mov rsi, 0
    mov rdx, 10 ; base 10
    call strtol
    pop rsi
    push rax

    ; pop arguments and call get_gcd
    pop rdi
    pop rsi
    call get_gcd

    ; print value
    mov rdi, print_number
    mov rsi, rax
    call printf

    ; exit
    mov rax, 0  ; 0--exit success
    pop rbp
    ret

incorrect_usage:
    mov rdi, bad_use_string
    ; rsi already contains argv
    mov rsi, [rsi]
    call printf
    mov rax, 0  ; 0--exit success
    pop rbp
    ret

bad_use_string:
    db "Usage: %s [number1] [number2]",10,0

print_number:
    db "%d",10,0

get_gcd:
    push rbp    ; set up stack frame
    mov rax, 0
    jmp loop

loop:
    ; keep adding the first argument
    ; to itself until a multiple
    ; is found. then, return
    add rax, rdi
    push rax
    mov rdx, 0
    div rsi
    cmp rdx, 0
    pop rax
    je gcd_found
    jmp loop

gcd_found:
    pop rbp
    ret
