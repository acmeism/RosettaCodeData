USING: combinators.short-circuit fry grouping hash-sets
http.client kernel math prettyprint sequences sequences.extras
sets sorting splitting ;

"https://www.mit.edu/~ecprice/wordlist.10000" http-get nip
"\n" split [ { [ length 3 < ] [ all-equal? ] } 1|| ] reject
[ [ all-rotations ] map ] [ >hash-set ] bi
'[ [ _ in? ] all? ] filter [ natural-sort ] map members .
