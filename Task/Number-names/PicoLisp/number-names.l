(de numName (N)
   (cond
      ((=0 N) "zero")
      ((lt0 N) (pack "minus " (numName (- N))))
      (T (numNm N)) ) )

(de numNm (N)
   (cond
      ((=0 N))
      ((> 14 N)
         (get '("one" "two" "three" "four" "five" "six" "seven" "eight" "nine" "ten" "eleven" "twelve" "thirteen") N) )
      ((= 15 N) "fifteen")
      ((= 18 N) "eighteen")
      ((> 20 N) (pack (numNm (% N 10)) "teen"))
      ((> 100 N)
         (pack
            (get '("twen" "thir" "for" "fif" "six" "seven" "eigh" "nine") (dec (/ N 10)))
            "ty"
            (unless (=0 (% N 10))
               (pack "-" (numNm (% N 10))) ) ) )
      ((rank N '((100 . "hundred") (1000 . "thousand") (1000000 . "million")))
         (pack (numNm (/ N (car @))) " " (cdr @) " " (numNm (% N (car @)))) ) ) )
