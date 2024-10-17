global _start

section .text

%define bsize 24
%define fd(w) qword[filedescriptor + w * 8]
%define sv(w) qword[rsp + w * 8]

_start:
    mov    fd(0), -1
    mov    fd(1), -1
    pop    r15
    cmp    r15, 1
    jle    .stdio0
    dec    r15
    add    rsp,      8
    xor    r14,      r14
 .readcmd:
    cmp    r14,      r15
    jge     .checkfd
    mov    r13,      sv(r14)
    cmp    dword[r13], `-if\0`
    je     .setif
    cmp    dword[r13], `-of\0`
    je     .setof
    cmp    word[r13],  "-h"
    je     .usage
    jmp    .readcmd
 .stdio0:
    mov    fd(0),    0
    mov    fd(1),    1
    jmp    .checkfd
 .setif:
    xor    rax,      rax
    inc    r14
    cmp    r14,      r15
    je     .checkfd
    mov    rdi,      sv(r14)
    cmp    dword[rdi], "stdi"
    je     .stif
    mov    rax,      2
    mov    rsi,      0
    mov    rdx,      0
    syscall
 .stif:
    mov    fd(0),    rax
    inc    r14
    jmp    .readcmd
 .setof:
    mov    rax,      1
    inc    r14
    cmp    r14,      r15
    jge     .checkfd
    mov    rdi,      sv(r14)
    cmp    dword[rdi], "stdo"
    je     .stof
    mov    rax,      85
    mov    rsi,      0o644
    syscall
 .stof:
    mov    fd(1),    rax
    inc    r14
    jmp    .readcmd
 .checkfd:
    cmp    fd(0),    -1
    jne    .cfd0
    mov    fd(0),    0
 .cfd0:
    cmp    fd(0),    -1
    jl     .err0
    cmp    fd(1),    -1
    jne    .cfd1
    cmp    fd(0),    -1
    jl     .err1
    mov    fd(1),    1
 .cfd1:
 .readwrite:
    sub    rsp,      8
 .read:
    xor    rax,      rax
    mov    rdi,      fd(0)
    mov    rsi,      rsp
    mov    rdx,      1
    syscall
    or     rax,      rax
    jz     .close0
 .rot13_:
    mov    dil,      byte[rsp]
    call   rot13byte
    mov    qword[rsp], rax
 .write:
    mov    rax,      1
    mov    rdi,      fd(1)
    mov    rsi,      rsp
    mov    rdx,      1
    syscall
    or     rax,      rax
    js     .close0
    jmp    .read
 .close0:
    add    rsp,      8
    cmp    fd(0),    2
    jle    .close1
    mov    rax,      3
    mov    rdi,      fd(0)
    syscall
 .close1:
    cmp    fd(1),    2
    jle    .exit0
    mov    rax,      3
    mov    rdi,      fd(1)
    syscall
 .exit0:
    mov    rax,      60
    mov    rdi,      0
    syscall
 .usage:
    mov    rax,      1
    mov    rdi,      1
    mov    rsi,      umsg
    mov    rdx,      endumsg - umsg
    syscall
    jmp .exit0
 .err0:
    mov    rax,      1
    mov    rdi,      1
    mov    rsi,      e0
    mov    rdx,      ende0 - e0
    syscall
    jmp    .close1
 .err1:
    mov    rax,      1
    mov    rdi,      1
    mov    rsi,      e1
    mov    rdx,      ende1 - e1
    syscall
    jmp    .usage
;------------------------------
rot13byte:
    push   rdi
    push   rdx
    push   rcx
    mov    rcx,    26
    mov    rax,    rdi
 .testupper:
    cmp    dil,    'A'
    jl    .return0
    cmp    dil,    'Z'
    jg    .testlower
 .rotupper:
    sub    rdi,    'A'
    add    rdi,    13
    xor    rdx,    rdx
    mov    rax,    rdi
    div    rcx
    mov    rax,    rdx
    add    rax,    'A'
    jmp   .return0
 .testlower:
    cmp    dil,    'a'
    jl    .return0
    cmp    dil,    'z'
    jg    .return0
 .rotlower:
    sub    rdi,    'a'
    add    rdi,    13
    xor    rdx,    rdx
    mov    rax,    rdi
    div    rcx
    mov    rax,    rdx
    add    rax,    'a'
 .return0:
    pop rcx
    pop rdx
    pop rdi
    ret

section .data
umsg:      db "Usage:", 0x0a
           db "rot13 [-if input_filename] [-of output_filename]", 0x0a
endumsg:
e0:        db "Error opening input file!", 0x0a
ende0:
e1:        db "Error opening output file!", 0x0a
ende1:

section .bss
filedescriptor  resq  2
