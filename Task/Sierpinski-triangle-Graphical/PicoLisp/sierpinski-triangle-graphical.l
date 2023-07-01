(de sierpinski (N)
   (let (D '("1")  S "0")
      (do N
         (setq
            D (conc
               (mapcar '((X) (pack S X S)) D)
               (mapcar '((X) (pack X "0" X)) D) )
            S (pack S S) ) )
      D ) )

(out '(display -)
   (let Img (sierpinski 7)
      (prinl "P1")
      (prinl (length (car Img)) " " (length Img))
      (mapc prinl Img) ) )
