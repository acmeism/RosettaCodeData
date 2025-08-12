procedure main()
     prod :=  1
      sum :=  0
        x := +5
        y := -5
        z := -2
      one :=  1
    three :=  3
    seven :=  7

    every j := resultsof {
        -three to        3^3 by  three ,
        -seven to     +seven by      x ,
           555 to    550 - y           ,
            22 to        -28 by -three ,
          1927 to       1939           ,
             x to          y by      z ,
          11^x to 11^x + one
    } do {
        sum := sum + abs(j)
        if abs(prod) < 2^27  &  j ~= 0 then prod := prod*j
    }
    write(" sum = ", sum)
    write("prod = ", prod)
end

procedure resultsof(celist)
    every ce := !celist do
        while e := @ce do suspend e
end
