(de longestCommonSubstring (Str1 Str2)
   (setq Str1 (chop Str1)  Str2 (chop Str2))
   (let Res NIL
      (map
         '((Lst1)
            (map
               '((Lst2)
                  (let Len 0
                     (find
                        '((A B) (nand (= A B) (inc 'Len)))
                        Lst1
                        Lst2 )
                     (when (> Len (length Res))
                        (setq Res (head Len Lst1)) ) ) )
               Str2 ) )
         Str1 )
      (pack Res) ) )
