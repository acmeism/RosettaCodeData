: d., ( n -- ) \ write double precision int, commatized.
    tuck dabs
    <# begin  2dup 1.000 d>  while  # # # [char] , hold  repeat #s rot sign #>
    type space ;

: .,  ( n -- ) \ write integer commatized.
    s>d d., ;

: 4*  s" 2 lshift" evaluate ; immediate
: 4/  s" 2 rshift" evaluate ; immediate

: isqrt-mod ( n -- z r )  \ n = r^2 + z
    1 begin 2dup >= while 4* repeat
    0 locals| r q z |
    begin q 1 > while
        q 4/ to q
        z r - q - \ t
        r 2/ to r
        dup 0>= if
            to z
            r q + to r
        else
            drop
        then
    repeat z r ;

: isqrt  isqrt-mod nip ;

: task1
    ." Integer square roots from 0 to 65:" cr
    66 0 do  i isqrt .  loop cr ;

: task2
    ." Integer square roots of 7^n" cr
    7 11 0 do
        i 2* 1+ 2 .r 3 spaces
        dup isqrt ., cr
        49 *
    loop ;

task1 cr task2 bye
