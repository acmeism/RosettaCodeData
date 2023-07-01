: walk ( a xt -- )
   >r begin ?dup while
     dup cell+ @ r@ execute
   @ repeat r> drop ;
