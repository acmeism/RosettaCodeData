(for L '([] ["ABC"] ["ABC", "DEF"] ["ABC", "DEF", "G", "H"])
   (let H (head -1 L)
      (prinl
         "{"
         (glue ", " H)
         (and H " and ")
         (last L)
         "}" ) ) )
