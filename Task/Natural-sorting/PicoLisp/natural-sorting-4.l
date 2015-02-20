(de *TestData
   "# Ignoring leading spaces"
   ("ignore leading spaces: 2-2" " ignore leading spaces: 2-1" "  ignore leading spaces: 2+0" "   ignore leading spaces: 2+1")

   "# Ignoring multiple adjacent spaces (m.a.s)"
   ("ignore m.a.s spaces: 2-2" "ignore m.a.s  spaces: 2-1" "ignore m.a.s   spaces: 2+0" "ignore m.a.s    spaces: 2+1")

   "# Equivalent whitespace characters"
   ("Equiv. spaces: 3-3" "Equiv.^Mspaces: 3-2" "Equiv.^Acspaces: 3-1" "Equiv.^Kbspaces: 3+0" "Equiv.^Jspaces: 3+1" "Equiv.^Ispaces: 3+2")

   "# Case Indepenent sort"
   ("cASE INDEPENENT: 3-2" "caSE INDEPENENT: 3-1" "casE INDEPENENT: 3+0" "case INDEPENENT: 3+1")

   "# Numeric fields as numerics"
   ("foo100bar99baz0.txt" "foo100bar10baz0.txt" "foo1000bar99baz10.txt" "foo1000bar99baz9.txt")

   "# Title sorts"
   ("The Wind in the Willows" "The 40th step more" "The 39 steps" "Wanda")

   "# Equivalent accented characters (and case)"
   ("Equiv. ý accents: 2-2" "Equiv. Ý accents: 2-1" "Equiv. y accents: 2+0" "Equiv. Y accents: 2+1")

   # "Separated ligatures"
   ### ("Ĳ ligatured ij" "no ligature")

   "# Character replacements"
   ("Start with an ʒ: 2-2" "Start with an ſ: 2-1" "Start with an ß: 2+0" "Start with an s: 2+1") )

(de pythonOut (Ttl Lst)
   (prinl Ttl)
   (prin "['" (car Lst))
   (for S (cdr Lst)
      (prin "',^J '" S) )
   (prinl "']") )

(for X *TestData
   (if (atom X)
      (prinl X)
      (pythonOut "Text strings:" X)
      (pythonOut "Normally sorted :" (sort (copy X)))
      (pythonOut "Naturally sorted:" (naturalSort X))
      (prinl) ) )
