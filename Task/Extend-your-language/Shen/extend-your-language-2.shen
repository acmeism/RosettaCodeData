(define try
  X Y -> (branch-if (integer? X)
                    (integer? Y)
           both-ints first-int second-int neither-int))

(map (/. X (do (print X) (nl)))
     [(try 1 2) (try 1 1.5) (try 1.5 1) (try 1.5 1.5)])
