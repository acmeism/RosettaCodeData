(de lastFridays (Y)
   (for M 12
      (prinl
         (dat$
            (find '((D) (= "Friday" (day D)))
               (mapcar '((D) (date Y M D)) `(range 31 22)) )
            "-" ) ) ) )
