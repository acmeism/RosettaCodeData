result :=
 Amb try:(1 to:11)                 in:[:x |
 Amb try:(1 to:11)                 in:[:y |
 Amb try:(1 to:11)                 in:[:z |
    (x squared + y squared = z squared) ifTrue:[
        {x . y . z}
    ].
 ]]].
Transcript showCR: e'found rectangle {result}'.
