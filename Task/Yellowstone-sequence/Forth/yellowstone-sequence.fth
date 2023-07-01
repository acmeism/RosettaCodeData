: array create cells allot ;
: th cells + ;                         \ some helper words

30 constant #yellow                    \ number of yellowstones

#yellow array y                        \ create array
                                       ( n1 n2 -- n3)
: gcd dup if tuck mod recurse exit then drop ;
: init 3 0 do i 1+ y i th ! loop ;     ( --)
: show cr #yellow 0 do y i th ? loop ; ( --)
: gcd-y[] - cells y + @ over gcd ;     ( k i n -- k gcd )
: loop1 begin 1+ over 2 gcd-y[] 1 = >r over 1 gcd-y[] 1 > r> or 0= until ;
: loop2 over true swap 0 ?do over y i th @ = if 0= leave then loop ;
: yellow #yellow 3 do i 3 begin loop1 loop2 until y rot th ! loop ;
: main init yellow show ;

main
