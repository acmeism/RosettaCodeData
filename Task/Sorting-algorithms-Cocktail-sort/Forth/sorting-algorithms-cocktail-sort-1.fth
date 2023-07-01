defer precedes                            ( addr addr -- flag )
                                          \ e.g. ' < is precedes
: sort                                    ( a n --)
  1- cells bounds 2>r false
  begin
    0= dup
  while
    2r@ ?do
       i cell+ @ i @ over over precedes   ( mark unsorted )
       if i cell+ ! i ! dup xor else drop drop then
    1 cells +loop
    0= dup
  while
    2r@ swap 1 cells - ?do
       i cell+ @ i @ over over precedes   ( mark unsorted )
       if i cell+ ! i ! dup xor else drop drop then
    -1 cells +loop
  repeat then drop 2r> 2drop
;
