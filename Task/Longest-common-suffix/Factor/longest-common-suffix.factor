USING: accessors grouping kernel prettyprint sequences
sequences.extras ;

! Like take-while, but for matrices and works from the rear.
: take-col-while-last ( ... matrix quot: ( ... col -- ... ? ) -- ... new-matrix )
    [ [ <reversed> ] map flip ] dip take-while ; inline

: lcs ( seq -- lcs )
    dup first swap [ all-equal? ] take-col-while-last to>> tail* ;

{ "baabababc" "baabc" "bbbabc" } lcs .
{ "baabababc" "baabc" "bbbazc" } lcs .
{ "" } lcs .
