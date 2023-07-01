: f-" ( a b snippet" -- )
  [char] " parse   ( code len )
  2dup 2>r evaluate
  swap 2r> evaluate
  - . ;

2 3 f-" dup *"   \ 5  (3*3 - 2*2)
