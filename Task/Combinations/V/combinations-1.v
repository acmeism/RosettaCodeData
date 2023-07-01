[comb [m lst] let
   [ [m zero?] [[[]]]
     [lst null?] [[]]
     [true] [m pred lst rest comb [lst first swap cons]  map
            m lst rest comb concat]
   ] when].
