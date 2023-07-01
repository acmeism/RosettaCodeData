(define x (expt 5 (expt 4 (expt 3 2))))
(print
   (div x (expt 10 (- (log 10 x) 20)))
   "..."
   (mod x (expt 10 20)))
(print "totally digits: " (log 10 x))
