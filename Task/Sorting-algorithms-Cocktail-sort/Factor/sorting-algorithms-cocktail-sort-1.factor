USING: kernel locals math math.ranges sequences ;

:: cocktail-sort! ( seq -- seq' )
    f :> swapped!                                         ! bind false to mutable lexical variable 'swapped'. This must be done outside both while quotations so it is in scope of both.
    [ swapped ] [                                         ! is swapped true? Then execute body quotation. 'do' executes body quotation before predicate on first pass.
        f swapped!                                        ! set swapped to false
        seq length 2 - [| i |                             ! for each i in 0 to seq length - 2 do
            i i 1 + [ seq nth ] bi@ >                     ! is element at index i greater than element at index i + 1?
            [ i i 1 + seq exchange t swapped! ] when      ! if so, swap them and set swapped to true
        ] each-integer
        swapped [                                         ! skip to end of loop if swapped is false
            seq length 2 - 0 [a,b] [| i |                 ! for each i in seq length - 2 to 0 do
                i i 1 + [ seq nth ] bi@ >                 ! is element at index i greater than element at index i + 1?
                [ i i 1 + seq exchange t swapped! ] when  ! if so, swap them and set swapped to true
            ] each
        ] when
    ] do while
    seq ;                                                 ! return the sequence
