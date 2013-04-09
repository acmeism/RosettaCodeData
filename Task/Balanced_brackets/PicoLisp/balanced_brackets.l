(load "@lib/simul.l")  # For 'shuffle'

(de generateBrackets (N)
   (shuffle (make (do N (link "[" "]")))) )

(de checkBrackets (S)
   (let N 0
      (for C S
         (if (= C "[")
            (inc 'N)
            (if2 (= C "]") (=0 N)
               (off N)
               (dec 'N) ) ) )
      (=0 N) ) )

(for N 10
   (prinl (if (checkBrackets (prin (generateBrackets N))) " OK" "not OK")) )
