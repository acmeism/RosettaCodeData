: ^2 dup * ;
: sqrt 0 tuck ?do 1+ dup 2* 1+ +loop ;
: topic >r r@ ^2 . r@ sqrt . r> drop ;

23 topic
