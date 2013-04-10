: arithmetic ( a b -- )
  cr ." a=" over . ." b=" dup .
  cr ." a+b=" 2dup + .
  cr ." a-b=" 2dup - .
  cr ." a*b=" 2dup * .
  cr ." a/b=" /mod .
  cr ." a mod b = " . cr ;
