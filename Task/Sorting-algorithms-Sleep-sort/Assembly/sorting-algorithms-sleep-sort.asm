    format ELF64 executable 3
    entry start

; parameters: argc, argv[] on stack
start:
    mov r12, [rsp]                      ; get argc
    mov r13, 1                          ; skip argv[0]

.getargv:
    cmp r13, r12                        ; check completion of args
    je .wait
    mov rdi, [rsp+8+8*r13]              ; get argv[n]
    inc r13

    mov rax, 57                         ; sys_fork
    syscall

    cmp rax, 0                          ; continue loop in main process
    jnz .getargv

    push rdi                            ; save pointer to sort item text

    call atoi_simple                    ; convert text to integer
    test rax, rax                       ; throw out bad input
    js .done

    sub rsp, 16                         ; stack space for timespec
    mov [rsp], rax                      ; seconds
    mov qword [rsp+8], 0                ; nanoseconds

    lea rdi, [rsp]
    xor rsi, rsi
    mov rax, 35                         ; sys_nanosleep
    syscall

    add rsp, 16

    pop rdi                             ; retrieve item text
    call strlen_simple

    mov rsi, rdi
    mov byte [rsi+rax], ' '
    mov rdi, 1
    mov rdx, rax
    inc rdx
    mov rax, 1                          ; sys_write
    syscall

    jmp .done

.wait:
    dec r12                             ; wait for each child process
    jz .done
    mov rdi, 0                          ; any pid
    mov rsi, 0
    mov rdx, 0
    mov r10, 4                          ; that has terminated
    mov rax, 247                        ; sys_waitid
    syscall

    jmp .wait

.done:
    xor rdi, rdi
    mov rax, 60                         ; sys_exit
    syscall

; parameter: rdi = string pointer
; return: rax = integer conversion
atoi_simple:
    push rdi
    push rsi

    xor rax, rax

.convert:
    movzx rsi, byte [rdi]
    test rsi, rsi                       ; check for null
    jz .done

    cmp rsi, '0'
    jl .baddigit
    cmp rsi, '9'
    jg .baddigit
    sub rsi, 48                         ; get ascii code for digit

    imul rax, 10                        ; radix 10
    add rax, rsi                        ; add current digit to total

    inc rdi
    jmp .convert

.baddigit:
    mov rax, -1                         ; return error code on failed conversion

.done:
    pop rsi
    pop rdi
    ret                                 ; return integer value

; parameter: rdi = string pointer
; return: rax = length
strlen_simple:
    xor rax, rax

.compare:
    cmp byte [rdi+rax], 0
    je .done
    inc rax
    jmp .compare

.done:
    ret
