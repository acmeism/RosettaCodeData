(de sierpinski (N)
   (let (D '("*")  S " ")
      (do N
         (setq
            D (conc
               (mapcar '((X) (pack S X S)) D)
               (mapcar '((X) (pack X " " X)) D) )
            S (pack S S) ) )
      D ) )

(mapc prinl (sierpinski 4))
