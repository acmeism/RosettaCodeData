USING: formatting kernel math.statistics math.vectors sequences ;

: area ( seq -- n )
    [ cum-max ] [ <reversed> cum-max reverse vmin ] [ v- sum ] tri ;

{
    { 1 5 3 7 2 }
    { 5 3 7 2 6 4 5 9 1 2 }
    { 2 6 3 5 2 8 1 4 2 2 5 3 5 7 4 1 }
    { 5 5 5 5 }
    { 5 6 7 8 }
    { 8 7 7 6 }
    { 6 7 10 7 6 }
} [ dup area "%[%d, %] -> %d\n" printf ] each
