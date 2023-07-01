digitalRoot :=
  [:nr :arIn |
    r := (nr printString asArray collect:#digitValue) sum.
    r > 9 ifTrue:[
       digitalRoot value:r value:arIn+1.
    ] ifFalse:[
       { arIn+1 .  r }
    ].
  ].

#(
   627615 39390 588225 393900588225 10 199
   1999999999999999999999999999999999999999999999999999999999999999999999999999999999999
) do:[:nr |
   Transcript showCR:'%1 has digitalRoot %3 and Additive Resistance %2'
              withArguments:{nr},(digitalRoot value:nr value:0)
]
