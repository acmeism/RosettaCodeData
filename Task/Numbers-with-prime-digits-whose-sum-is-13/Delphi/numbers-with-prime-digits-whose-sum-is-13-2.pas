USING: io kernel math prettyprint sequences sequences.extras ;

{ } { { 2 } { 3 } { 5 } { 7 } } [
    { 2 3 5 7 } [ suffix ] cartesian-map concat
    [ sum 13 = ] partition [ append ] dip [ sum 11 > ] reject
] until-empty [ bl ] [ [ pprint ] each ] interleave nl
