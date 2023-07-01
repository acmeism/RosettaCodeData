result :=
  Amb
    until:[:solution |
        (Dialog confirm: e'Found solution: {solution}\nSee more?') not
    ] in:[
       Amb try:(1 to:100)                 in:[:x |
       Amb try:(1 to:100)                 in:[:y |
          y <= x ifTrue:[
            Amb try:(1 to:100)            in:[:z |
              (x squared + y squared = z squared) ifTrue:[
                {x . y . z} ]]]]]].
Transcript showCR: result.
