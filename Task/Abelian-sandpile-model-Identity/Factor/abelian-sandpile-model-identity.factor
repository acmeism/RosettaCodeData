USING: arrays grouping io kernel math math.vectors prettyprint
qw sequences ;

CONSTANT: neighbors {
    { 1 3 } { 0 2 4 } { 1 5 } { 0 4 6 } { 1 3 5 7 }
    { 2 4 8 } { 3 7 } { 4 6 8 } { 5 7 }
}

! Sandpile words
: find-tall ( seq -- n ) [ 3 > ] find drop ;
: tall? ( seq -- ? ) find-tall >boolean ;
: distribute ( ind seq -- ) [ [ 1 + ] change-nth ] curry each ;
: adjacent ( n seq -- ) [ neighbors nth ] dip distribute ;
: shrink ( n seq -- ) [ 4 - ] change-nth ;
: (topple) ( n seq -- ) [ shrink ] [ adjacent ] 2bi ;
: topple ( seq -- seq' ) [ find-tall ] [ (topple) ] [ ] tri ;
: avalanche ( seq -- ) [ dup tall? ] [ topple ] while drop ;
: s+ ( seq1 seq2 -- seq3 ) v+ dup avalanche ;

! Output words
: mappend ( seq1 seq2 -- seq3 ) [ flip ] bi@ append flip ;
: sym ( seq str -- seq ) 1array " " 1array tuck 3array mappend ;
: arrow ( seq -- new-seq ) ">" sym ;
: plus  ( seq -- new-seq ) "+" sym ;
: eq    ( seq -- new-seq ) "=" sym ;
: topple> ( seq seq -- seq seq ) arrow over topple 3 group mappend ;
: (.s+) ( seq seq seq -- seq ) [ plus ] [ mappend eq ] [ mappend ] tri* ;
: .s+ ( seq1 seq2 -- ) 2dup s+ [ 3 group ] tri@ (.s+) simple-table. ;

! Task
CONSTANT: s1 { 1 2 0 2 1 1 0 1 3 }
CONSTANT: s2 { 2 1 3 1 0 1 0 1 0 }
CONSTANT: s3 { 3 3 3 3 3 3 3 3 3 }
CONSTANT: id { 2 1 2 1 0 1 2 1 2 }

"Avalanche:" print nl
{ 4 3 3 3 1 2 0 2 3 }
dup 3 group topple> topple> topple> topple> nip simple-table. nl

"s1 + s2 = s2 + s1" print nl
s1 s2 .s+ nl s2 s1 .s+ nl

"s3 + s3_id = s3" print nl
s3 id .s+ nl

"s3_id + s3_id = s3_id" print nl
id id .s+
