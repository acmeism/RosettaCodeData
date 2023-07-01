(gc 32)
(de gcd (A B)
   (until (=0 B)
      (let M (% A B)
         (setq A B B M) ) )
   (abs A) )
(de totient (N)
   (let C 0
      (for I N
         (and (=1 (gcd N I)) (inc 'C)) )
      (cons C (= C (dec N))) ) )
(de p? (N)
   (let C 0
      (for A N
         (and
            (cdr (totient A))
            (inc 'C) ) )
      C ) )
(let Fmt (3 7 10)
   (tab Fmt "N" "Phi" "Prime?")
   (tab Fmt "-" "---" "------")
   (for N 25
      (tab Fmt
         N
         (car (setq @ (totient N)))
         (cdr @) ) ) )
(println
   (mapcar p? (25 100 1000 10000 100000)) )
