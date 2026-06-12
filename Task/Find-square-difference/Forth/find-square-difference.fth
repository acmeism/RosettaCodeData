: square dup * ;
: square-diff
  0 begin 1+
  dup square over 1- square -
  1000 > until . ;

square-diff
