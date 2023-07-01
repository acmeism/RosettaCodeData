(de isin (Str)
   (let Str (mapcar char (chop Str))
      (and
         (= 12 (length Str))
         (<= 65 (car Str) 90)
         (<= 65 (cadr Str) 90)
         (luhn
            (pack
               (mapcar
                  '((N)
                     (- N (if (<= 48 N 57) 48 55)) )
                  Str ) ) ) ) ) )
(println
   (mapcar
      isin
      (quote
         "US0378331005"
         "US0373831005"
         "U50378331005"
         "US03783310005"
         "AU0000XVGZA3"
         "AU0000VXGZA3"
         "FR0000988040" ) ) )
