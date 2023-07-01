: report ( n -- ) ?dup if ." caught " . else ." no throw" then ;
: test ( -- )
  ['] f catch report
  ['] g catch report ;
