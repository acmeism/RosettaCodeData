;; Given num, return num and the list of its divisors
(= divisor (fn (num)
   (= dlist '())
   (when (is 1 num) (= dlist '(1 0)))
   (when (is 2 num) (= dlist '(2 1)))
   (unless (or (is 1 num) (is 2 num))
   (up i 1 (+ 1 (/ num 2))
     (if (is 0 (mod num i))
         (push i dlist)))
   (= dlist (cons num dlist)))
   dlist))

;; Find out what number has the most divisors between 2 and 20,000.
;; Print a list of the largest known number's divisors as it is found.
(= div-lists (fn (cnt (o show 0))
  (= tlist '()) (= clist tlist)
  (when (> show 0) (prn tlist))
  (up i 1 cnt
    (divisor i)
    (when (is 1 show) (prn dlist))
    (when (>= (len dlist) (len tlist))
        (= tlist dlist)
        (when (is show 2) (prn tlist))
        (let c (- (len dlist) 1)
        (push (list i c) clist))))

  (= many-divisors (list ((clist 0) 1)))
  (for n 0 (is ((clist n) 1) ((clist 0) 1)) (= n (+ 1 n))
    (push ((clist n) 0) many-divisors))
  (= many-divisors (rev many-divisors))
  (prn "The number with the most divisors under " cnt
       " has " (many-divisors 0) " divisors.")
  (prn "It is the number "
  (if (> 2 (len many-divisors)) (cut (many-divisors) 1)
      (many-divisors 1)) ".")
  (prn "There are " (- (len many-divisors) 1) " numbers"
       " with this trait, and they are "
       (map [many-divisors _] (range 1 (- (len many-divisors) 1))))
  (prn (map [divisor _] (cut many-divisors 1)))
  many-divisors))

;; Do the tasks
(div-lists 10 1)
(div-lists 20000)
;; This took about 10 minutes on my machine.
