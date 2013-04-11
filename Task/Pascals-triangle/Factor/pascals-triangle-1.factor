USING: grouping kernel math sequences ;

: (pascal) ( seq -- newseq )
    dup last 0 prefix 0 suffix 2 <clumps> [ sum ] map suffix ;

: pascal ( n -- seq )
    1 - { { 1 } } swap [ (pascal) ] times ;
