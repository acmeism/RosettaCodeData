: Reverse          #27  emit "[7m" type ;
: Normal           #27 emit "[m" type ;

: test cr Reverse ."   Reverse " cr  Normal ."  Normal  " ;
test
