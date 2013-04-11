(de grayEncode (N)
   (bin (x| N (>> 1 N))) )

(de grayDecode (G)
   (bin
      (pack
         (let X 0
            (mapcar
               '((C) (setq X (x| X (format C))))
               (chop G) ) ) ) ) )
