include FMS-SI.f
include FMS-SILib.f

: union {: a b -- c :}
  begin
    b each:
  while dup
    a indexOf: if 2drop else a add: then
  repeat b <free a dup sort: ; ok

i{ 2 5 4 3 } i{ 5 6 7 } union p: i{ 2 3 4 5 6 7 } ok


: free2 ( a b -- ) <free <free ;
: intersect {: a b | c -- c :}
  heap> 1-array2 to c
  begin
    b each:
  while dup
    a indexOf: if drop c add: else drop then
  repeat a b free2 c dup sort: ;

i{ 2 5 4 3 } i{ 5 6 7 } intersect p: i{ 5 } ok


: diff {: a b | c -- c :}
  heap> 1-array2 to c
  begin
    a each:
  while dup
    b indexOf: if 2drop else c add: then
  repeat a b free2 c dup sort: ;

i{ 2 5 4 3 } i{ 5 6 7 } diff p: i{ 2 3 4 } ok

: subset {: a b -- flag :}
  begin
    a each:
  while
    b indexOf: if drop else false exit then
  repeat a b free2 true ;

i{ 2 5 4 3 } i{ 5 6 7 } subset . 0 ok
i{ 5 6 } i{ 5 6 7 } subset .  -1 ok


: set= {: a b -- flag :}
  a size: b size: <> if a b free2 false exit then
  a sort: b sort:
  begin
    a each: drop b each:
  while
    <> if a b free2 false exit then
  repeat a b free2 true ;

i{ 5 6 } i{ 5 6 7 } set= .  0 ok
i{ 6 5 7 } i{ 5 6 7 } set= .  -1 ok
