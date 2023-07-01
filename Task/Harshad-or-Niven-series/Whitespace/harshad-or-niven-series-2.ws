push 0 ; Harshad numbers found
push 0 ; counter

0:  ; Increment the counter, call "digsum", branch on the modulus.
    push 1 add dup dup
    push 0 call 1 mod
        jz 2
        jump 0

1:  ; [n 0] => [digsum(n)]
    copy 1
    push 10 mod add swap
    push 10 div swap
    push 0 copy 2 sub
        jn 1
        slide 1 ret

2:  ; Should we print this Harshad number?
    push 1000 copy 1 sub jn 3 ; We're done if it's greater than 1000.
    swap push 1 add swap      ; Increment how many we've found so far.
    push 20 copy 2 sub jn 0   ; If we've already got 20, go back to the top.
    dup onum push 32 ochr     ; Otherwise, print it and a space.
    jump 0                    ; And /then/ go back to the top.

3:  ; Print the > 1000 Harshad number on its own line and exit clean.
    push 10 ochr onum pop push 10 ochr exit
