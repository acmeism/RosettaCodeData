(let Str (chop "This is a string")
   (prinl (head 4 (nth Str 6)))        # From 6 of 4 length
   (prinl (nth Str 6))                 # From 6 up to the end
   (prinl (head -1 Str))               # Minus last character
   (prinl (head 8 (member "s" Str)))   # From character "s" of length 8
   (prinl                              # From "isa" of length 8
      (head 8
         (seek '((S) (pre? "is a" S)) Str) ) ) )
