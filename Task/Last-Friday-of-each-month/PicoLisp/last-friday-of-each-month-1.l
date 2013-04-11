(de lastFridays (Y)
   (for M `(range 1 12)
      (prinl
         (dat$
            (find '((D) (= "Friday" (day D)))
               (mapcar '((D) (date Y M D)) `(range 31 22)) )
            "-" ) ) ) )
