defer precedes
defer exchange

: gnomesort                   ( a n)
  swap >r 1                   ( n c)
  begin                       ( n c)
    over over >               ( n c f)
  while                       ( n c)
    dup if                    ( n c)
      dup dup 1- over over r@ precedes
      if r@ exchange 1- else drop drop 1+ then
    else 1+ then              ( n c)
  repeat drop drop r> drop    ( --)
;

create example
  8 93 69 52 50 79 33 52 19 77 , , , , , , , , , ,

:noname >r cells r@ + @ swap cells r> + @ swap < ; is precedes
:noname >r cells r@ + swap cells r> + over @ over @ swap rot ! swap ! ; is exchange

: .array 10 0 do example i cells + ? loop cr ;

.array example 10 gnomesort .array
