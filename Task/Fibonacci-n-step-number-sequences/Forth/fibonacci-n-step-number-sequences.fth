: length @ ;                          \ length of an array is stored at its address
: a{ here cell allot ;
: } , here over - cell / over ! ;

defer nacci

: step ( a- i n -- a- i m )
    >r 1- 2dup nacci r> + ;

: steps ( a- i n -- m )
    0 tuck do step loop nip nip ;

:noname ( a- i -- n )
    over length over >                \ if i is within the array
    if cells + @                      \ fetch i...if not,
    else over length 1- steps         \ get length of array for calling step and recurse
    then ; is nacci

: show-nacci 11 1 do dup i nacci . loop cr drop ;

." fibonacci: " a{ 1 , 1 } show-nacci
." tribonacci: " a{ 1 , 1 , 2 } show-nacci
." tetranacci: " a{ 1 , 1 , 2 , 4 } show-nacci
." lucas: " a{ 2 , 1 } show-nacci
