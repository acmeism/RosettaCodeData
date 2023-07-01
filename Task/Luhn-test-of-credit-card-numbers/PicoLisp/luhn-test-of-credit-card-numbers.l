(de luhn (Num)  # 'Num' may be a number or a string
   (=0
      (%
         (sum
            '((C F)
               (setq C (- (char C) 48))
               (if F
                  C                               # Odd
                  (+ (/ C 5) (% (* 2 C) 10)) ) )  # Even
            (flip (chop Num))
            '(T NIL .) )
         10 ) ) )
