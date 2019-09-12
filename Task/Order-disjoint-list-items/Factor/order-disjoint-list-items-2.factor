USING: assocs combinators combinators.smart effects formatting
fry kernel qw sequences ;
IN: rosetta-code.order-disjoint-list

: make-slot ( seq elt -- )
    dupd [ = ] curry find drop swap [ \ _ ] 2dip set-nth ;

: make-slots ( seq elts -- seq' ) dupd [ make-slot ] with each ;

: reorder ( seq elts -- seq' )
    tuck make-slots [ ] like over { "x" } <effect>
    '[ _ fry _ call-effect ] input<sequence ; inline

: show-reordering ( seq elts -- )
    2dup [ clone ] dip reorder [ " " join ] tri@
    "M: %-23s N: %-8s M': %s\n" printf ; inline

{
    { qw{ the cat sat on the mat } qw{ mat cat } }
    { qw{ the cat sat on the mat } qw{ cat mat } }
    { qw{ A B C A B C A B C      } qw{ C A C A } }
    { qw{ A B C A B D A B E      } qw{ E A D A } }
    { qw{ A B                    } qw{ B       } }
    { qw{ A B                    } qw{ B A     } }
    { qw{ A B B A                } qw{ B A     } }
}
[ show-reordering ] assoc-each
