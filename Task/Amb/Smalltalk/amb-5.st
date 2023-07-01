result :=
  Amb allSolutions:[
    Amb try:(1 to:11)                 in:[:x |
    Amb try:(1 to:11)                 in:[:y |
      y <= x ifTrue:[
        Amb try:(1 to:11)            in:[:z |
          (x squared + y squared = z squared) ifTrue:[
            {x . y . z} ]]]]]].
Transcript showCR: e'all rectangles: {result}'.
