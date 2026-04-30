use16
format MZ
entry code:start

segment code
start:
;----Define the data segment----
    mov    ax, data0     ;load the address of data segment into ax
    mov    ds, ax        ;load address of the data segment into
                         ;data segment register
;-------------------------------
    lea    di, [msg]     ;load address of message into di
    call   pascalprint   ;call the routine that prints a pascal string

exit:
    mov    ax, 0x4c00    ;load 4c into ah, al is error code.
    int    0x21          ;exit to dos

pascalprint:             ;routine to print a pascal string.
    movzx  cx, byte[di]  ;load the first byte into cx. The length of string
    mov    dx, di        ;load into dx the address of string
    inc    dx            ;add one to dx, because the second byte is the
                         ;start of the string.
    mov    bx, 1         ;1 is file description of stdout
    mov    ax, 0x4000    ;service 40h writes a string to file
                         ;in this case the file is stdout.
    int    0x21          ;call the interrupt.
    ret                  ;return from routine.

segment data0
;A pascal string is a string where the first byte is the length
;of the string. That means that the string is limited to 255 bytes long.
;the length is calculated by the assembler.
msg:     db @f-$-1, "Hello world!"
 @@:
