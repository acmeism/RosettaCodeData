(load "pluser/sieve.l")  # See the task "Sieve of Eratosthanes"

(setq NthPrime '(
            (     10 . 29)
            (    100 . 541)
            (   1000 . 7919)
            (  10000 . 104729)
            ( 100000 . 1299709)
            (1000000 . 15485863)))

(de conspiracy (Power)
   (let (Upto (cdr (assoc (** 10 Power) NthPrime)))
      (if Upto
         (report Upto)
         (prog (prinl "Sorry, I don't know the value of the 1e" Power "th prime number.") NIL))))

(de report (Upto)
   (for Count (tally Upto)
      (let (((A . B) . C) Count)
         (prinl A " -> " B ": " C)))
   NIL)

(de tally (Upto)
   (let
      (Transitions
         (maplist '((L)
                     (and
                        (cdr L)
                        (cons
                           (% (car L) 10)
                           (% (cadr L) 10))))
                     (sieve Upto)))
      (let (Tally NIL)
         (for Pair Transitions
            (setq Tally (bump-trans Pair Tally)))
         (cdr (sort Tally)))))   # NOTE: After sorting, first element is NIL
                                 # (since the last element from the maplist call is NIL)

(de bump-trans (Trans Tally)
   (cond
      ((== Tally NIL)
         (list (cons Trans 1)))
      ((= Trans (caar Tally))
         (cons (cons Trans (inc (cdar Tally))) (cdr Tally)))
      (T
         (cons (car Tally) (bump-trans Trans (cdr Tally))))))
