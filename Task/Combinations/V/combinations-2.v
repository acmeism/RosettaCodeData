[comb
   [ [pop zero?] [pop pop [[]]]
     [null?] [pop pop []]
     [true] [ [m lst : [m pred lst rest comb [lst first swap cons]  map
            m lst rest comb concat]] view i ]
   ] when].
