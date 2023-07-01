USING: accessors combinators io kernel math.order prettyprint
sequences sorting ;

TUPLE: table-sorter
    data
    { column initial: 0 }
    reversed?
    { ordering initial: [ ] } ;

: <table-sorter> ( -- obj ) table-sorter new ;

: sort-table ( table-sorter -- matrix )
    {
        [ data>> ]
        [ column>> [ swap nth ] curry ]
        [ ordering>> compose ]
        [ reversed?>> [ >=< ] [ <=> ] ? [ bi@ ] prepose curry ]
    } cleave [ sort ] curry call( x -- x ) ;


! ===== Now we can use the interface defined above =====

CONSTANT: table
    { { "a" "b" "c" } { "" "q" "z" } { "can" "z" "a" } }

"Unsorted" print
table simple-table.

"Default sort" print
<table-sorter>
    table >>data
sort-table simple-table.

"Sorted by col 2" print
<table-sorter>
    table >>data
    2 >>column
sort-table simple-table.

"Sorted by col 1" print
<table-sorter>
    table >>data
    1 >>column
sort-table simple-table.

"Reverse sorted by col 1" print
<table-sorter>
    table >>data
    1 >>column
    t >>reversed?
sort-table simple-table.

"Sorted by decreasing length" print
<table-sorter>
    table >>data
    t >>reversed?
    [ length ] >>ordering
sort-table simple-table.
