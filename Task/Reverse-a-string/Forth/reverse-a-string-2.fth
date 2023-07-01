\ reverse a string using the data stack for temporary storage

: mystring ( -- caddr len) S" ABCDEFGHIJKLMNOPQRSTUVWXYZ987654321" ;

: pushstr ( caddr len -- c..c[n])   bounds  do  I c@  loop ;
: popstr  ( c.. c[n] caddr len -- ) bounds  do  I c!  loop ;
: reverse ( caddr len  -- ) 2dup 2>r  pushstr  2r> popstr ;
