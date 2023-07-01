; Accumulator factory
; Returns a function that returns the sum of all numbers ever passed in
; Build:
;   nasm -felf32 af.asm
;   ld -m elf32_i386 af.o -o af

global  _start
section .text

_start:
    mov eax, 0x2D       ; sys_brk(unsigned long brk)
    xor ebx, ebx        ; Returns current break on an error
    int 0x80            ; syscall
    push    eax         ; Save the initial program break

    push    2           ; Get an accumulator initialized to 2
    call    factory
    mov [acc1], eax     ; Save the pointer in acc1

    push    5           ; Get an accumulator initialized to 5
    call    factory
    mov [acc2], eax     ; Save the pointer in acc2

    push    4           ; Call acc1 with 4
    lea eax, [acc1]
    call    [eax]

    push    4           ; Call acc2 with 4
    lea eax, [acc2]
    call    [eax]

    push    -9          ; Call acc1 with -9
    lea eax, [acc1]
    call    [eax]

    push    13          ; Call acc1 with 13
    lea eax, [acc1]
    call    [eax]

    push    eax         ; Print the number, should be 10
    call    print_num

    push    -5          ; Call acc2 with -5
    lea eax, [acc2]
    call    [eax]

    push    eax         ; Print the number, should be 4
    call    print_num

    mov eax, 0x2D       ; Reset the program break
    pop ebx
    int 0x80

    mov eax, 0x01       ; sys_exit(int error)
    xor ebx, ebx        ; error = 0 (success)
    int 0x80

; int (*function)(int) factory (int n)
; Returns a pointer to a function that returns the sum of all numbers passed
; in to it, including the initial parameter n;
factory:
    push    ebp         ; Create stack frame
    mov ebp, esp
    push    ebx
    push    edi
    push    esi

    mov eax, 0x2D       ; Allocate memory for the accumulator
    xor ebx, ebx
    int 0x80
    push    eax         ; Save the current program break
    mov ebx, .acc_end   ; Calculate the new program break
    sub ebx, .acc
    push    ebx         ; Save the length
    add ebx, eax
    mov eax, 0x2D
    int 0x80

    pop ecx             ; Copy the accumulator code into memory
    pop eax             ; Set the returned address
    mov edi, eax
    mov esi, .acc
    rep movsb
    lea edi, [eax + 10] ; Copy the parameter to initialize accumulator
    lea esi, [ebp + 8]
    movsd

    pop esi             ; Tear down stack frame
    pop edi
    pop ebx
    mov esp, ebp
    pop ebp
    ret 4               ; Return and remove parameter from stack

.acc:                   ; Start of the returned accumulator
    push    ebp
    mov ebp, esp
    push    edi
    push    esi

    call    .acc_skip   ; Jumps over storage, pushing address to stack
    dd  0               ; The accumulator storage (32 bits)
.acc_skip:
    pop esi             ; Retrieve the accumulator using address on stack
    lodsd
    add eax, [ebp + 8]  ; Add the parameter
    lea edi, [esi - 4]
    stosd               ; Save the new value

    pop esi
    pop edi
    mov esp, ebp
    pop ebp
    ret 4
.acc_end:               ; End of accumulator

; void print_num (int n)
; Prints a positive integer and a newline
print_num:
    push    ebp
    mov ebp, esp

    mov eax, [ebp + 8]  ; Get the number
    lea ecx, [output + 10]  ; Put a newline at the end
    mov BYTE [ecx], 0x0A
    mov ebx, 10         ; Divisor
.loop:
    dec ecx             ; Move backwards in string
    xor edx, edx
    div ebx
    add edx, 0x30       ; Store ASCII digit
    mov [ecx], dl
    cmp eax, 0          ; Loop until all digits removed
    jnz .loop

    mov eax, 0x04       ; sys_write(int fd, char *buf, int len)
    mov ebx, 0x01       ; stdout
    lea edx, [output + 11]  ; Calulate length
    sub edx, ecx
    int 0x80

    mov esp, ebp
    pop ebp
    ret 4

section .bss
acc1:                   ; Variable that stores the first accumulator
    resd    1
acc2:                   ; Variable that stores the second accumulator
    resd    1
output:                 ; Holds the output buffer
    resb    11
