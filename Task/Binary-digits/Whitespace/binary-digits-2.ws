push 0
; Increment indefinitely.
0:
    push -1 ; Sentinel value so the printer knows when to stop.
    copy 1
    call 1
    push 10
    ochr
    push 1
    add
    jump 0
; Get the binary digits on the stack in reverse order.
1:
    dup
    push 2
    mod
    swap
    push 2
    div
    push 0
    copy 1
    sub
    jn 1
    pop
; Print them.
2:
    dup
    jn 3 ; Stop at the sentinel.
    onum
    jump 2
3:
    pop
    ret
