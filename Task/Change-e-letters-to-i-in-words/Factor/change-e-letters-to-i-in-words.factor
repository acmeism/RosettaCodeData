USING: assocs binary-search formatting io.encodings.ascii
io.files kernel literals math sequences splitting ;

CONSTANT: words $[ "unixdict.txt" ascii file-lines ]

words
[ length 5 > ] filter
[ CHAR: e swap member? ] filter
[ dup "e" "i" replace ] map>alist
[ nip words sorted-member? ] assoc-filter   ! binary search
[ "%-9s -> %s\n" printf ] assoc-each
