wordlist constant dict

: load-dict ( c-addr u -- )
    r/o open-file throw >r
    begin
	pad 1024 r@ read-line throw while
	    pad swap ['] create execute-parsing
    repeat
    drop r> close-file throw ;

: xreverse {: c-addr u -- c-addr2 u :}
    u allocate throw u + c-addr swap over u + >r begin ( from to r:end)
	over r@ u< while
	    over r@ over - x-size dup >r - 2dup r@ cmove
	    swap r> + swap repeat
    r> drop nip u ;

: .example ( c-addr u u1 -- )
    5 < if
	cr 2dup type space 2dup xreverse 2dup type drop free throw then
    2drop ;

: nt-semicheck ( u1 nt -- u2 f )
    dup >r name>string xreverse 2dup dict find-name-in dup if ( u1 c-addr u nt2)
	r@ < if ( u1 c-addr u ) \ count pairs only once and not palindromes
	    2dup 4 pick .example
	    rot 1+ -rot then
    else
	drop then
    drop free throw r> drop true ;

get-current dict set-current s" unixdict.txt" load-dict set-current

0 ' nt-semicheck dict traverse-wordlist cr .
cr bye
