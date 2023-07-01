(de vigenereKey (Str)
   (extract
      '((C)
         (when (>= "Z" (uppc C) "A")
            (- (char (uppc C)) 65) ) )
      (chop Str) ) )

(de vigenereEncrypt (Str Key)
   (pack
      (mapcar
         '((C K)
            (char (+ 65 (% (+ C K) 26))) )
         (vigenereKey Str)
         (apply circ (vigenereKey Key)) ) ) )

(de vigenereDecrypt (Str Key)
   (pack
      (mapcar
         '((C K)
            (char (+ 65 (% (+ 26 (- C K)) 26))) )
         (vigenereKey Str)
         (apply circ (vigenereKey Key)) ) ) )
