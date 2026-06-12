: concat-self
    dup dup
    begin dup while
        1 rshift
        swap 1 lshift swap
    repeat
    drop or
;

: print-bits
    0 swap
    begin
        dup 1 and '0 +
        swap 1 rshift
    dup 0= until drop
    begin dup while emit repeat drop
;

: to1000
    1
    begin dup concat-self dup 1000 < while
        dup . 9 emit print-bits cr
        1+
    repeat
    2drop
;

to1000 bye
