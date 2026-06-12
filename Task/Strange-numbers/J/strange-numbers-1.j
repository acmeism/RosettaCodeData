isStrange=: ([: */ 2 3 5 7 e.&:|~ 2 -/\ 10 #.inv ])"0

strangePair=: (1 p: ::0:"0 i.10),. 0 1}.isStrange (+ 10&*)"0/~ i.10
