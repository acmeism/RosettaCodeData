;Assemble with: tasm, tlink /t
;assume direction bit is clear (so si increments)
        .model  tiny
        .code
        org     100h
start:  mov     si, offset msg  ;point to message
        jmp     pr20

pr10:   mov     ah, 0           ;write character to printer
        mov     dx, 0           ;LPT1
        int     17h
pr20:   lodsb                   ;al, ds:[si++]
        cmp     al, 0           ;terminator?
        jne     pr10            ;loop if not
        ret                     ;return to OS

msg     db      "Hello World!", 0ch, 0  ;0ch = form feed (for laser printer)
        end     start
