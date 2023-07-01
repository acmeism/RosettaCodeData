(de shuffle (Lst)
   (by '(NIL (rand)) sort Lst) )

# Extend this class with a `next-guess>` method and a `str>` method.
(class +Strategy +Entity)
(dm prev-drawer> (Num)
   (=: prev Num) )

(class +Random +Strategy)
(dm T (Prisoner)
   (=: guesses (nth (shuffle (range 1 100)) 51)) )
(dm next-guess> ()
   (pop (:: guesses)) )
(dm str> ()
   "Random" )

(class +Optimal +Strategy)
(dm T (Prisoner)
   (=: prisoner-id Prisoner) )
(dm next-guess> ()
   (or (: prev) (: prisoner-id)) )
(dm str> ()
   "Optimal/Wikipedia" )


(de test-strategy (Strategy)
   "Simulate one round of 100 prisoners who use `Strategy`"
   (let Drawers (shuffle (range 1 100))
      (for Prisoner (range 1 100)
         (NIL # Break and return NIL if any prisoner fails their test.
            (let Strat (new (list Strategy) Prisoner)
               (do 50 # Try 50 iterations of `Strat`. Break and return T iff success.
                  (T (= Prisoner (prev-drawer> Strat (get Drawers (next-guess> Strat))))
                     T ) ) ) )
         T ) ) )

(de test-strategy-n-times (Strategy N)
   "Simulate `N` rounds of 100 prisoners who use `Strategy`"
   (let Successes 0
      (do N
         (when (test-strategy Strategy)
            (inc 'Successes) ) )
      (prinl "We have a " (/ (* 100 Successes) N) "% success rate with " N " trials.")
      (prinl "This is using the " (str> Strategy) " strategy.") ) )
