: .exists ( str len -- )
    2dup file-status nip 0= if
        ." exists: "
    else
        ." does not exist: "
    then
    type
;

s" input.txt" .exists cr
s" /input.txt" .exists cr
s" docs" .exists cr
s" /docs" .exists cr
