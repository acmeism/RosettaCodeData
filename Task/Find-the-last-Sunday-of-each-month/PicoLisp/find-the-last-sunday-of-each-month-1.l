(de lastSundays (Y)
   (for M 12
      (prinl
         (dat$
            (find '((D) (= "Sunday" (day D)))
               (mapcar '((D) (date Y M D)) `(range 31 22)) )
            "-" ) ) ) )
