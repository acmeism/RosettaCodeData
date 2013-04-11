push 1 ; Initialize a counter.

0:
    dup dup ; Get two copies for the mod checks.
    push 3 mod jz 1
    push 5 mod jz 2
    dup onum jump 4 ; If we're still here, just print the number.

1:  ; Print "Fizz", then maybe "Buzz".
    push F ochr
    push i ochr
    call 3 push 5 mod
        jz 2
        jump 4

2:  ; Print "Buzz".
    push B ochr
    push u ochr
    call 3 jump 4

3:  ; Print "zz"; called as a function for convenient return.
    push z dup ochr ochr ret

4:
    push 10 ochr   ; Print a newline.
    push 1 add dup ; Increment the counter.
    push 101 sub
        jn 0       ; Go again unless we're at 100.
        pop exit   ; Exit clean.
