USING: formatting io.encodings.ascii io.files kernel literals
math sequences sequences.extras sets strings ;

<< CONSTANT: words $[ "unixdict.txt" ascii file-lines ] >>

CONSTANT: wordset $[ words HS{ } set-like ]

: word? ( str -- ? ) wordset in? ;

: subwords ( str -- str str )
    dup <evens> >string swap <odds> >string ;

: alternade? ( str -- ? ) subwords [ word? ] both? ;

words
[ alternade? ] filter
[ length 5 > ] filter
[ dup subwords "%-8s %-4s %-4s\n" printf ] each
