( SVG ouput )

: draw-line ( direction -- ) \ line-length=10 ; sin(60)=0.87 ; cos(60)=0.5
  case
  0 of s" h 10"      type cr endof
  1 of s" l  5  8.7" type cr endof
  2 of s" l -5  8.7" type cr endof
  3 of s" h -10"     type cr endof
  4 of s" l -5 -8.7" type cr endof
  5 of s" l  5 -8.7" type cr endof
  endcase
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

: raw. ( u -- ) 0 <# #s #> type ;

: svg-start
  dup 1 swap lshift 10 * ( -- order image-width ) \ image-width is 2 power order
  s" sierpinski_arrowhead.svg" w/o create-file throw to outfile-id
  s" <svg xmlns='http://www.w3.org/2000/svg' width='" type dup raw.
  87 * 100 / ( -- order image-height ) \ image-height; sin(60)=0.87
  s" ' height='" type raw. s" '>" type cr
  s" <rect width='100%' height='100%' fill='white'/>" type cr
  s" <path stroke-width='1' stroke='black' fill='none' d='" type cr
  s" M 0 0" type cr
;
: svg-end
  s" '/> </svg>" type cr
  outfile-id close-file throw
;

: arrowhead ( order -- )
  outfile-id >r svg-start
  0 'A curve
  svg-end r> to outfile-id
;

5 arrowhead
