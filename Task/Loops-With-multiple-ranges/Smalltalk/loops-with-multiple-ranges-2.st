prod := 1.
sum := 0.
x := 5.
y := -5.
z := -2.
one := 1.
three := 3.
seven := 7.

action :=
    [:j |
       sum := sum + j abs.
        ((prod abs < (2**27)) and:[ j ~= 0 ]) ifTrue:[
            prod := prod*j
        ].
    ].

(three negated to: 3**3  by: three       ) do:action.
(seven negated to: seven by: x           ) do:action.
(555           to: 550-y                 ) do:action.
(22            to: -28  by: three negated) do:action.
(1927          to: 1939                  ) do:action.
(x             to: y    by:z             ) do:action.
(11**x         to: 11**x + one           ) do:action.
Transcript show:' sum = '; showCR:sum.
Transcript show:'prod = '; showCR:prod
