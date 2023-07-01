USING: combinators io kernel regexp sequences sets splitting
wrap.strings ;

! courtesy of https://www.infoplease.com/common-abbreviations

CONSTANT: common-abbreviations {
    "A.B." "abbr." "Acad." "A.D." "alt." "A.M." "Assn."
    "at. no." "at. wt." "Aug." "Ave." "b." "B.A." "B.C." "b.p."
    "B.S." "c." "Capt." "cent." "co." "Col." "Comdr." "Corp."
    "Cpl." "d." "D.C." "Dec." "dept." "dist." "div." "Dr." "ed."
    "est." "et al." "Feb." "fl." "gal." "Gen." "Gov." "grad."
    "Hon." "i.e." "in." "inc." "Inst." "Jan." "Jr." "lat."
    "Lib." "long." "Lt." "Ltd." "M.D." "Mr." "Mrs." "mt." "mts."
    "Mus." "no." "Nov." "Oct." "Op." "pl." "pop." "pseud." "pt."
    "pub." "Rev." "rev." "R.N." "Sept." "Ser." "Sgt." "Sr."
    "St." "uninc." "Univ." "U.S." "vol." "vs." "wt."
}

: sentence-enders ( str -- newstr )
    R/ \)/ "" re-replace
    " " split harvest
    unclip-last swap
    [ common-abbreviations member? ] reject
    [ last ".!?" member? ] filter
    swap suffix ;

: serious? ( str -- ? ) last CHAR: . = ;
: neutral? ( str -- ? ) last ".!?" member? not ;
: mixed? ( str -- ? ) "?!" intersect length 2 = ;
: exclamation? ( str -- ? ) last CHAR: ! = ;
: question? ( str -- ? ) last CHAR: ? = ;

: type ( str -- newstr )
    {
        { [ dup serious? ] [ drop "S" ] }
        { [ dup neutral? ] [ drop "N" ] }
        { [ dup mixed? ] [ drop "EQ" ] }
        { [ dup exclamation? ] [ drop "E" ] }
        { [ dup question? ] [ drop "Q" ] }
        [ drop "UNKNOWN" ]
    } cond ;

: sentences ( str -- newstr )
    sentence-enders [ type ] map "|" join ;

: show ( str -- )
    dup sentences " -> " glue 60 wrap-string print ;

"Hi there, how are you today? I'd like to present to you the washing machine 9001. You have been nominated to win one of these! Just make sure you don't break it" show
nl
"(There was nary a mouse stirring.) But the cats were going
bonkers!" show
nl
"\"Why is the car so slow?\" she said." show
nl
"Hello, Mr. Anderson!" show
nl
"Are you sure?!?! How can you know?" show
