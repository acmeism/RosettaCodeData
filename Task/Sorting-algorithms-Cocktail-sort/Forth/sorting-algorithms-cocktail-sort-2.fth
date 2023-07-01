: sort
  1- cells bounds 1
  begin
    >r over over r@ -rot true -rot
    r> 0< if 1 cells - then
    ?do
      i cell+ @ i @ over over precedes     ( mark unsorted )
      if i cell+ ! i ! dup xor else drop drop then
    over cells +loop
    >r negate >r swap r@ cells + r> r>
  until drop drop drop
;
