( ASCII output with use of ANSI terminal control )

: draw-line ( direction -- )
  case
  0 of  .\" _"              endof ( horizontal right:          _          )
  1 of  .\" \e[B\\"         endof (       down right:     CUD  \          )
  2 of  .\" \e[D\e[B/\e[D"  endof (        down left: CUB CUD  /  CUB     )
  3 of  .\" \e[D_\e[D"      endof (  horizontal left:     CUB  _  CUB     )
  4 of  .\" \e[D\\\e[A\e[D" endof (          up left:     CUB  \  CUU CUB )
  5 of  .\" /\e[A"          endof (         up right:          /  CUU     )
  endcase                         ( cursor is up-right of the last point  )
;

: turn+ 1+ 6 mod ;
: turn- 1- 6 mod ;

defer curve
: A-rule ( order direction -- ) turn+  2dup 'B curve  turn-  2dup 'A curve  turn-  'B curve ;
: B-rule ( order direction -- ) turn-  2dup 'A curve  turn+  2dup 'B curve  turn+  'A curve ;

:noname ( order direction type -- )
  2 pick 0 = if drop draw-line drop exit then \ draw line when order is 0
  rot 1- rot rot
  'A = if A-rule else B-rule then
; is curve


: arrowhead ( order -- )
  page
  s" Sierpinski arrowhead curve of order " type dup . cr
  s" =====================================" type cr
  0 'A curve
;

5 arrowhead
