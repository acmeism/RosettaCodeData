(let (Count 1000000  Denom 27720  N Denom)
   (let Probs
      (mapcar
         '((I S)
            (prog1 (cons N (*/ Count I) 0 S)
               (dec 'N (/ Denom I)) ) )
         (range 5 12)
         '(aleph beth gimel daleth he waw zayin heth) )
      (do Count
         (inc (cddr (rank (rand 1 Denom) Probs T))) )
      (let Fmt (-6 12 12)
         (tab Fmt NIL "Probability" "Result")
         (for X Probs
            (tab Fmt
               (cdddr X)
               (format (cadr X) 6)
               (format (caddr X) 6) ) ) ) ) )
