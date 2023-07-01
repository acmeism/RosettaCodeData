(de stripCtrl (Str)
   (pack
      (filter
         '((C)
            (nor (= "^?" C) (> " " C "^A")) )
         (chop Str) ) ) )

(de stripCtrlExt (Str)
   (pack
      (filter
         '((C) (> "^?" C "^_"))
         (chop Str) ) ) )
