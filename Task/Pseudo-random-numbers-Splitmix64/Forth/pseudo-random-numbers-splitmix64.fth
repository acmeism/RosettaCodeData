variable rnd-state

: rnd-base-op ( z factor shift -- u ) 2 pick swap rshift rot xor * ;

: rnd-next ( -- u )
  $9e3779b97f4a7c15 rnd-state +!
  rnd-state @
  $bf58476d1ce4e5b9 #30 rnd-base-op
  $94d049bb133111eb #27 rnd-base-op
  #1 #31 rnd-base-op
;

#1234567 rnd-state !
cr
rnd-next u. cr
rnd-next u. cr
rnd-next u. cr
rnd-next u. cr
rnd-next u. cr


: rnd-next-float ( -- f )
  rnd-next 0 d>f 0 1 d>f f/
;

create counts 0 , 0 , 0 , 0 , 0 ,
: counts-fill
  #987654321 rnd-state !
  100000 0 do
    rnd-next-float 5.0e0 f* f>d drop cells counts + dup @ 1+ swap !
  loop
;
: counts-disp
  5 0 do
    cr i . ': emit bl emit
    counts i cells + @ .
  loop cr
;

counts-fill counts-disp
