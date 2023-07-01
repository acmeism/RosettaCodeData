: .exists ( str len -- ) 2dup file-status nip 0= if ."  exists" else ."  does not exist" then type ;
 s" input.txt" .exists
s" /input.txt" .exists
 s" docs" .exists
s" /docs" .exists
