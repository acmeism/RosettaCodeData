(de timePlus12 (Str)
   (use (@Mon @Day @Year @Time @Zone)
      (and
         (match
            '(@Mon " " @Day " " @Year " " @Time " " @Zone)
            (chop Str) )
         (setq @Mon (index (pack @Mon) *MonFmt))
         (setq @Day (format @Day))
         (setq @Year (format @Year))
         (setq @Time
            (case (tail 2 @Time)
               (("a" "m") ($tim (head -2 @Time)))
               (("p" "m") (+ `(time 12 0) ($tim (head -2 @Time))))
               (T ($tim @Time)) ) )
         (let? Date (date @Year @Mon @Day)
            (when (>= (inc '@Time `(time 12 0)) 86400)
               (dec '@Time 86400)
               (inc 'Date) )
            (pack (dat$ Date "-") " " (tim$ @Time T) " " @Zone) ) ) ) )
