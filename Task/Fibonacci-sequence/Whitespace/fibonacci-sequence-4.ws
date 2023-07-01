; Read n.
push 0
dup
inum
load

; Call fib(n), ouput the result and a newline, then exit.
call 0
onum
push 10
ochr
exit

0:
    dup
    push 2
    sub
    jn 1   ; Return if n < 2.
    dup
    push 1
    sub
    call 0 ; Call fib(n - 1).
    swap   ; Get n back into place.
    push 2
    sub
    call 0 ; Call fib(n - 2).
    add    ; Leave the sum on the stack.
1:
    ret
