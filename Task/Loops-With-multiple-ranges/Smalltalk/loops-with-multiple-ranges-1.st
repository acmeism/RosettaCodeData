prod := 1.
sum := 0.
x := 5.
y := -5.
z := -2.
one := 1.
three := 3.
seven := 7.

(three negated to: 3**3  by: three       ) ,
(seven negated to: seven by: x           ) ,
(555           to: 550-y                 ) ,
(22            to: -28  by: three negated) ,
(1927          to: 1939                  ) ,
(x             to: y    by:z             ) ,
(11**x         to: 11**x + one           )
    do:[:j |
        sum := sum + j abs.
        ((prod abs < (2**27)) and:[ j ~= 0 ]) ifTrue:[
            prod := prod*j
        ].
    ].
Transcript show:' sum = '; showCR:sum.
Transcript show:'prod = '; showCR:prod
