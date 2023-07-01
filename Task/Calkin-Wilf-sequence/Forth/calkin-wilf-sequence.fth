\ Calkin-Wilf sequence

: frac.  swap . ." / " . ;
: cw-next ( num den -- num den )  2dup / over * 2* over + rot - ;
: cw-seq ( n -- )
  1 1 rot
  0 do
    cr 2dup frac. cw-next
  loop 2drop ;

variable index
variable bit-state
variable bit-position
: r2cf-next ( num1 den1 -- num2 den2 u )  swap over >r s>d r> sm/rem ;

: n2bitlength ( n -- )
  bit-state @ if
    1 swap lshift 1-   bit-position @ lshift    index +!
  else drop then ;

: index-init   true bit-state !    0 bit-position !    0 index ! ;
: index-build ( n -- )
  dup n2bitlength    bit-position +!    bit-state @ invert bit-state ! ;
: index-finish ( n 0 -- ) 2drop    -1 bit-position +!    1 index-build ;

: cw-index ( num den -- )
  index-init
  begin    r2cf-next index-build    dup 0<> while    repeat
  index-finish ;

: cw-demo
  20 cw-seq
  cr 83116 51639 2dup frac. cw-index index @ . ;
cw-demo
