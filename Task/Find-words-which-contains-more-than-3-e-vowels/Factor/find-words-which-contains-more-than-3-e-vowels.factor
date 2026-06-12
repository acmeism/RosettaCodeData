USING: formatting io io.encodings.ascii io.files kernel math
sequences ;

"unixdict.txt" ascii file-lines
[ [ "aiou" member? ] any? ] reject
[ [ CHAR: e = ] count 3 > ] filter
[ 1 + "%2d: " printf print ] each-index
