: cycle-length { x0 'f -- lambda }  \ Brent's algorithm stage 1
    1 1 x0 dup 'f execute
    begin 2dup <> while
        2over = if
            2swap nip 2* 0
            2swap nip dup
        then
        'f execute rot 1+ -rot
    repeat 2drop nip ;

: iterations ( x f n -- x )
    >r swap r> 0 ?do over execute loop nip ;

: cycle-start { x0 'f lambda -- mu }  \ Brent's algorithm stage 2
    0 x0 dup 'f lambda iterations
    begin 2dup <> while
        swap 'f execute  swap 'f execute  rot 1+ -rot
    repeat 2drop ;

: find-cycle ( x0 'f -- mu lambda )  \ Brent's algorithm
    2dup cycle-length dup >r cycle-start r> ;

\ --- usage ---

: .cycle { start len x0 'f -- }
    x0
    start 1- 0 do  'f execute  loop
    len 0 do 'f execute dup .  loop
    drop ;

: f(x)  dup * 1+ 255 mod ;

3 ' f(x) find-cycle
." The cycle starts at offset " over . ." and has a length of " dup . cr
." The cycle is " 3 ' f(x) .cycle cr
bye
