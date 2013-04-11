push 127
; Initialize a slot in the heap for each ASCII character.
0:
    dup
    push 0
    store
    push 1
    sub
    dup
    jn 1
    jump 0
; Read until EOF, incrementing the relevant heap slot.
1:
    push 0
    dup
    ichr
    load
    dup
    jn 2 ; Done reading, proceed to print.
    dup
    load
    push 1
    add
    store
    jump 1
; Stack is [-1 -1], but [0] would be nice.
2:
    sub
; Print characters with tallies greater than 0.
3:
    push 1
    add
    dup
    push 128
    sub
    jz 4 ; All done.
    dup
    load
    jz 3 ; Don't print if no occurrences.
    dup
    ochr ; Display the character,
    push 32
    ochr ; a space,
    dup
    load
    onum ; its frequency,
    push 10
    ochr ; and a newline.
    jump 3
4:
    pop
    exit
