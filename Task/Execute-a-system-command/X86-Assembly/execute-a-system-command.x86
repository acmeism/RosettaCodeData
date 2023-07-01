; Executes '/bin/ls'
; Build with:
;   nasm -felf32 execls.asm
;   ld -m elf_i386 execls.o -o execls

global  _start
section .text

_start:
    mov eax, 0x0B       ; sys_execve(char *str, char **args, char **envp)
    mov ebx, .path      ; pathname
    push DWORD 0
    push DWORD .path
    lea ecx, [esp]      ; arguments [pathname]
    xor edx, edx        ; environment variables []
    int 0x80            ; syscall
.path:
    db  '/bin/ls', 0x00
