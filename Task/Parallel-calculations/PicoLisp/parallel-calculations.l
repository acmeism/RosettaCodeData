(let Lst
   (mapcan
      '((N)
         (later (cons)               # When done,
            (cons N (factor N)) ) )  # return the number and its factors
      (quote
         188573867500151328137405845301  # Process a collection of 12 numbers
         3326500147448018653351160281
         979950537738920439376739947
         2297143294659738998811251
         136725986940237175592672413
         3922278474227311428906119
         839038954347805828784081
         42834604813424961061749793
         2651919914968647665159621
         967022047408233232418982157
         2532817738450130259664889
         122811709478644363796375689 ) )
   (wait NIL (full Lst))  # Wait until all computations are done
   (maxi '((L) (apply min L)) Lst) )  # Result: Number in CAR, factors in CDR
