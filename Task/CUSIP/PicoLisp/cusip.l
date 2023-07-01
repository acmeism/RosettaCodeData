(de cusip (Str)
   (let (Str (mapcar char (chop Str))  S 0)
      (for (I . C) (head 8 Str)
         (let V
            (cond
               ((<= 48 C 57) (- C 48))
               ((<= 65 C 90) (+ 10 (- C 65)))
               ((= C 42) 36)
               ((= C 64) 37)
               ((= C 35) 38) )
            (or
               (bit? 1 I)
               (setq V (>> -1 V)) )
            (inc
               'S
               (+ (/ V 10) (% V 10)) ) ) )
      (=
         (- (last Str) 48)
         (% (- 10 (% S 10)) 10) ) ) )

(println
   (mapcar
      cusip
      (quote
         "037833100"
         "17275R102"
         "38259P508"
         "68389X106"
         "68389X105" ) ) )
