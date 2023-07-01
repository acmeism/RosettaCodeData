USING: assocs combinators.random formatting grouping io kernel
macros math math.statistics namespaces prettyprint quotations
random sequences sorting ;
IN: sequence-mutation

SYMBOL: verbose?  ! Turn on to show mutation details.
                  ! Off by default.

! Return a random base as a character.
: rand-base ( -- n ) "ACGT" random ;

! Generate a random dna sequence of length n.
: <dna> ( n -- seq ) [ rand-base ] "" replicate-as ;

! Prettyprint a dna sequence in blocks of n.
: .dna ( seq n -- )
    "SEQUENCE:" print [ group ] keep
    [ * swap "  %3d: %s\n" printf ] curry each-index ;

! Show a histogram of bases in a dna sequence and their total.
: show-counts ( seq -- )
    "BASE COUNTS:" print histogram >alist [ first ] sort-with
    [ [ "    %c: %3d\n" printf ] assoc-each ]
    [ "TOTAL: " write [ second ] [ + ] map-reduce . ] bi ;

! Prettyprint the overall state of a dna sequence.
: show-dna ( seq -- ) [ 50 .dna nl ] [ show-counts nl ] bi ;

! Call a quotation only if verbose? is on.
: log ( quot -- ) verbose? get [ call ] [ drop ] if ; inline

! Set index n to a random base.
: bswap ( n seq -- seq' )
    [ rand-base ] 2dip 3dup [ nth ] keepd spin
    [ "  index %3d: swapping  %c with %c\n" printf ] 3curry log
    [ set-nth ] keep ;

! Remove the base at index n.
: bdelete ( n seq -- seq' )
    2dup dupd nth [ "  index %3d: deleting  %c\n" printf ]
    2curry log remove-nth ;

! Insert a random base at index n.
: binsert ( n seq -- seq' )
    [ rand-base ] 2dip over reach
    [ "  index %3d: inserting %c\n" printf ] 2curry log
    insert-nth ;

! Allow "passing" probabilities to casep. This is necessary
! because casep is a macro.
MACRO: build-casep-seq ( seq -- quot )
    { [ bswap ] [ bdelete ] [ binsert ] } zip 1quotation ;

! Mutate a dna sequence according to some weights.
! For example,
! "ACGT" { 0.1 0.3 0.6 } mutate
! means swap with 0.1 probability, delete with 0.3 probability,
! and insert with 0.6 probability.
: mutate ( dna-seq weights-seq -- dna-seq' )
    [ [ length random ] keep ] [ build-casep-seq ] bi* casep ;
    inline

! Prettyprint a sequence of weights.
: show-weights ( seq -- )
    "MUTATION PROBABILITIES:" print
    "  swap:   %.2f\n  delete: %.2f\n  insert: %.2f\n\n" vprintf
    ;

: main ( -- )
    verbose? on "ORIGINAL " write 200 <dna> dup show-dna 10
    { 0.2 0.2 0.6 } dup show-weights "MUTATION LOG:" print
    [ mutate ] curry times nl "MUTATED " write show-dna ;

MAIN: main
