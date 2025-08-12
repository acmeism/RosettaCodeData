procedure main()
     prod :=  1
      sum :=  0
        x := +5
        y := -5
        z := -2
      one :=  1
    three :=  3
    seven :=  7

    i_to_h_by_k := proc("...",3)  # i_to_h_by_k(i,h,k)
                                  # same as "i to h by k"
    every j := i_to_h_by_k ! ![
        [ -three ,        3^3 ,  three ] ,
        [ -seven ,     +seven ,      x ] ,
        [    555 ,    550 - y ,    one ] ,  # list of argument lists
        [     22 ,        -28 , -three ] ,  #      (i,h,k)
        [   1927 ,       1939 ,    one ] ,
        [      x ,          y ,      z ] ,
        [   11^x , 11^x + one ,    one ]
    ] do {
        sum := sum + abs(j)
        if abs(prod) < 2^27  &  j ~= 0 then prod := prod*j
    }
    write(" sum = ", sum)
    write("prod = ", prod)
end
