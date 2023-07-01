USING: assocs io kernel literals math math.factorials
math.parser math.ranges prettyprint qw random sequences
splitting ;
RENAME: factoradic math.combinatorics.private => _factoradic
RENAME: rotate sequences.extras => _rotate
IN: rosetta-code.factorial-permutations

CONSTANT: shoe $[
    qw{ A K Q J 10 9 8 7 6 5 4 3 2 } qw{ ♠ ♥ ♦ ♣ }
    [ append ] cartesian-map flip concat
]

! Factor can already make factoradic numbers, but they always
! have a least-significant digit of 0 to remove.
: factoradic ( n -- seq )
    _factoradic dup [ drop but-last ] unless-empty ;

! Convert "3.1.2.0" to { 3 1 2 0 }, for example.
: string>factoradic ( str -- seq )
    "." split [ string>number ] map ;

! Rotate a subsequence.
! E.g. 0 2 { 3 1 2 0 } (rotate) -> { 2 3 1 0 }.
: (rotate) ( from to seq -- newseq )
    [ 1 + ] dip [ snip ] [ subseq ] 3bi -1 _rotate glue ;

! Only rotate a subsequence if from does not equal to.
: rotate ( from to seq -- newseq )
    2over = [ 2nip ] [ (rotate) ] if ;

! The pseudocode from the task description
: fpermute ( factoradic -- permutation )
    dup length 1 + <iota> swap <enumerated>
    [ over + rot rotate ] assoc-each ;

! Use a factoradic number to index permutations of a collection.
: findex ( factoradic seq -- permutation )
    [ fpermute ] [ nths concat ] bi* ;

: .f ( seq -- ) [ "." write ] [ pprint ] interleave ;   ! Print a factoradic number
: .p ( seq -- ) [ pprint ] each nl ;                    ! Print a permutation

: show-table ( -- )
    "Generate table" print 24
    [ factoradic 3 0 pad-head dup .f fpermute " -> " write .p ]
    each-integer nl ;

: show-shuffles ( -- )
    "Generate given task shuffles" print
    "Original deck:" print shoe concat print nl
    "39.49.7.47.29.30.2.12.10.3.29.37.33.17.12.31.29.34.17.25.2.4.25.4.1.14.20.6.21.18.1.1.1.4.0.5.15.12.4.3.10.10.9.1.6.5.5.3.0.0.0"
    "51.48.16.22.3.0.19.34.29.1.36.30.12.32.12.29.30.26.14.21.8.12.1.3.10.4.7.17.6.21.8.12.15.15.13.15.7.3.12.11.9.5.5.6.6.3.4.0.3.2.1"
    [ [ print ] [ string>factoradic shoe findex print nl ] bi ] bi@ ;

: show-random-shuffle ( -- )
    "Random shuffle:" print
    51 52 [ n! ] bi@ [a,b] random factoradic shoe findex print ;

: main ( -- ) show-table show-shuffles show-random-shuffle ;

MAIN: main
