get-current get-order wordlist swap 1+ set-order definitions
: place		over >r rot over cell+ r> move ! ;
: +place	2dup >r >r dup @ cell+ + swap move r> r> dup @ rot + swap ! ;
: count		dup cell+ swap @ ;
set-current

CREATE eol	10 C,  DOES> 1 ;
CREATE eod	128 ALLOT  DOES> count ;
: seteod	0 parse ['] eod >body place ;
: start		0 0 here place ;
: read		refill  0= IF abort" Unterminated here document" THEN ;
: ~end		source eod compare ;
: store		source here +place  eol here +place ;
: slurp		BEGIN read ~end WHILE store REPEAT  refill drop ;
: totalsize	here count + here - ;
: finish	totalsize ALLOT  align ;
: <<		seteod  start slurp finish  DOES> count ;
previous

( Test )

CREATE Alice << ~~ end ~~
They got a building down New York City, it’s called Whitehall Street,
Where you walk in, you get injected, inspected, detected, infected,
Neglected and selected.
~~ end ~~

Alice type  bye
