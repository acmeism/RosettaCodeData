1000000 constant limit
create kr_sequence limit 1+ cells allot

: kr cells kr_sequence + ;

: init_kr_sequence
    1 1 1 1 { i2 i3 m2 m3 }
    limit 1+ 1 do
        m2 m3 min dup i kr !
        dup m2 = if
            i2 kr @ 2* 1+ to m2
            i2 1+ to i2
        then
        m3 = if
            i3 kr @ 3 * 1+ to m3
            i3 1+ to i3
        then
    loop ;

: main
    init_kr_sequence
    ." The first 100 elements of the Klarner-Rado sequence:" cr
    101 1 do
        i kr @ 3 .r
        i 10 mod 0= if cr else space then
    loop
    cr
    1000
    begin
        dup limit <=
    while
        ." The "
        dup 1 .r
        ." th element of the Klarner-Rado sequence is "
        dup kr @ 1 .r cr
        10 *
    repeat
    drop
;

main
bye
