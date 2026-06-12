(load "@lib/simul.l")  # For 'subsets'

(pick
   '((N)
      (find '((L) (=0 (sum cdr L)))
         (subsets N *Words) ) )
   (range 1 (length *Words)) )
