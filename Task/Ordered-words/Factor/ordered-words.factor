USING: fry grouping io io.encodings.utf8 io.files kernel math
math.order sequences unicode.case ;
IN: ordered-words

CONSTANT: dict-file "vocab:ordered-words/unixdict.txt"

: word-list ( -- seq )
    dict-file utf8 file-lines ;

: ordered-word? ( word -- ? )
    >lower 2 <clumps> [ first2 <= ] all? ;

: filter-longest-words ( seq -- seq' )
    dup [ length ] [ max ] map-reduce
    '[ length _ = ] filter ;

: main ( -- )
    word-list [ ordered-word? ] filter
    filter-longest-words [ print ] each ;
