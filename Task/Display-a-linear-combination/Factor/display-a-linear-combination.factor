USING: formatting kernel match math pair-rocket regexp sequences ;

MATCH-VARS: ?a ?b ;

: choose-term ( coeff i -- str )
    1 + { } 2sequence {
        {  0  _ } => [       ""                 ]
        {  1 ?a } => [ ?a    "e(%d)"    sprintf ]
        { -1 ?a } => [ ?a    "-e(%d)"   sprintf ]
        { ?a ?b } => [ ?a ?b "%d*e(%d)" sprintf ]
    } match-cond ;

: linear-combo ( seq -- str )
    [ choose-term ] map-index harvest " + " join
    R/ \+ -/ "- " re-replace [ "0" ] when-empty ;

{ { 1 2 3 } { 0 1 2 3 } { 1 0 3 4 } { 1 2 0 } { 0 0 0 } { 0 }
  { 1 1 1 } { -1 -1 -1 } { -1 -2 0 -3 } { -1 } }
[ dup linear-combo "%-14u  ->  %s\n" printf ] each
