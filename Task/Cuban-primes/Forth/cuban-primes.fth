include ./miller-rabin.fs

\ commatized print
\
: d.,r ( d n -- ) \ write double precision int, commatized.
    >r tuck dabs
    <# begin  2dup 1.000 d>  while  # # # [char] , hold  repeat #s rot sign #>
    r> over - spaces type ;

: .,r  ( n1 n2 -- ) \ write integer commatized.
    >r s>d r> d.,r ;


\ generate and print cuban primes
\
: sq  s" dup *" evaluate ; immediate
: next-cuban ( n -- n' p )
    begin
        1+ dup sq 3 * 1+ dup 3 and 0=  \ first check == 0 (mod 4)
        if 2 rshift dup prime?
            if exit
            else drop
            then
        else drop
        then
    again ;

: task1
    1
    20 0 do
        cr 10 0 do
            next-cuban 12 .,r
        loop
    loop drop ;

: task2
    cr ." The 100,000th cuban prime is "
    1  99999 0 do next-cuban drop loop next-cuban 0 .,r drop ;


task1 cr
task2 cr
bye
