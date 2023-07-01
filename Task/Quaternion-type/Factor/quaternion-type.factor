USING: generalizations io kernel locals math.quaternions
math.vectors prettyprint sequences ;
IN: rosetta-code.quaternion-type

: show ( quot -- )
    [ unparse 2 tail but-last "= " append write ] [ call . ] bi
    ; inline

: 2show ( quots -- )
    [ 2curry show ] map-compose [ call ] each ; inline

: q+n ( q n -- q+n ) n>q q+ ;

[let
    { 1 2 3 4 } 7 { 2 3 4 5 } { 3 4 5 6 } :> ( q r q1 q2 )
    q [ norm ]
    q [ vneg ]
    q [ qconjugate ]
    [ curry show ] 2tri@
    {
        [ q  r  [ q+n ] ]
        [ q  r  [ q*n ] ]
        [ q1 q2 [ q+  ] ]
        [ q1 q2 [ q*  ] ]
        [ q2 q1 [ q*  ] ]
    } 2show
]
