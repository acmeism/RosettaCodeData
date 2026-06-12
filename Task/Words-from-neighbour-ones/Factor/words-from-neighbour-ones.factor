USING: formatting grouping hash-sets io.encodings.ascii io.files
kernel literals math math.matrices sequences sequences.extras
sets strings ;

<< CONSTANT: words $[ "unixdict.txt" ascii file-lines ] >>

CONSTANT: wordset $[ words >hash-set ]

words                                       ! place word list on data stack
[ length 9 < ] reject                       ! remove small words from list
9 <clumps>                                  ! create virtual sequence of every 9 adjacent words (overlapping)
[ main-diagonal >string ]                   ! map clump to its diagonal
[ wordset in? ] map-filter                  ! filter diagonals that are words
members                                     ! remove duplicates
[ 1 + swap "%2d. %s\n" printf ] each-index  ! print words formatted nicely
