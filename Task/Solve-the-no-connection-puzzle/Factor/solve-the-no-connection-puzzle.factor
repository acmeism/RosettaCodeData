USING: assocs interpolate io kernel math math.combinatorics
math.ranges math.parser multiline pair-rocket sequences
sequences.generalizations ;

STRING: diagram
    ${}   ${}
   /|\ /|\
  / | X | \
 /  |/ \|  \
${} - ${} - ${} - ${}
 \  |\ /|  /
  \ | X | /
   \|/ \|/
    ${}   ${}
;

CONSTANT: adjacency
H{
    0 => { 2 3 4 }
    1 => { 3 4 5 }
    2 => { 0 3 6 }
    3 => { 0 1 2 4 6 7 }
    4 => { 0 1 3 5 6 7 }
    5 => { 1 4 7 }
    6 => { 2 3 4 }
    7 => { 3 4 5 }
}

: any-consecutive? ( seq n -- ? ) [ - abs 1 = ] curry any? ;

: neighbors ( elt seq i -- seq elt )
    adjacency at swap nths swap ;

: solution? ( permutation-seq -- ? )
    dup [ neighbors any-consecutive? ] with find-index nip not ;

: find-solution ( -- seq )
    8 [1,b] [ solution? ] find-permutation ;

: display-solution ( seq -- )
    [ number>string ] map 8 firstn diagram interpolate>string
    print ;

: main ( -- ) find-solution display-solution ;

MAIN: main
