USING: arrays combinators.extras fry io kernel math.matrices
prettyprint random sequences sets ;
IN: rosetta-code.random-latin-squares

: rand-permutation ( n -- seq ) <iota> >array randomize ;
: ls? ( n -- ? ) [ all-unique? ] column-map t [ and ] reduce ;
: (ls) ( n -- m ) dup '[ _ rand-permutation ] replicate ;
: ls ( n -- m ) dup (ls) dup ls? [ nip ] [ drop ls ] if ;
: random-latin-squares ( -- ) [ 5 ls simple-table. nl ] twice ;

MAIN: random-latin-squares
