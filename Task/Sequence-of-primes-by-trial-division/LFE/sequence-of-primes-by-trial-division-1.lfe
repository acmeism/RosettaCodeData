(defmodule tdwheel
   (export
      (primes 0) (gen 1) (next 1)))

(defun +wheel-2x3x5x7x11+ ()
   #B( 12  4  2  4  6  2  6  4  2  4  6  6  2  6  4  2  6  4  6  8  4  2  4  2
        4 14  4  6  2 10  2  6  6  4  2  4  6  2 10  2  4  2 12 10  2  4  2  4
        6  2  6  4  6  6  6  2  6  4  2  6  4  6  8  4  2  4  6  8  6 10  2  4
        6  2  6  6  4  2  4  6  2  6  4  2  6 10  2 10  2  4  2  4  6  8  4  2
        4 12  2  6  4  2  6  4  6 12  2  4  2  4  8  6  4  6  2  4  6  2  6 10
        2  4  6  2  6  4  2  4  2 10  2 10  2  4  6  6  2  6  6  4  6  6  2  6
        4  2  6  4  6  8  4  2  6  4  8  6  4  6  2  4  6  8  6  4  2 10  2  6
        4  2  4  2 10  2 10  2  4  2  4  8  6  4  2  4  6  6  2  6  4  8  4  6
        8  4  2  4  2  4  8  6  4  6  6  6  2  6  6  4  2  4  6  2  6  4  2  4
        2 10  2 10  2  6  4  6  2  6  4  2  4  6  6  8  4  2  6 10  8  4  2  4
        2  4  8 10  6  2  4  8  6  6  4  2  4  6  2  6  4  6  2 10  2 10  2  4
        2  4  6  2  6  4  2  4  6  6  2  6  6  6  4  6  8  4  2  4  2  4  8  6
        4  8  4  6  2  6  6  4  2  4  6  8  4  2  4  2 10  2 10  2  4  2  4  6
        2 10  2  4  6  8  6  4  2  6  4  6  8  4  6  2  4  8  6  4  6  2  4  6
        2  6  6  4  6  6  2  6  6  4  2 10  2 10  2  4  2  4  6  2  6  4  2 10
        6  2  6  4  2  6  4  6  8  4  2  4  2 12  6  4  6  2  4  6  2 12  4  2
        4  8  6  4  2  4  2 10  2 10  6  2  4  6  2  6  4  2  4  6  6  2  6  4
        2 10  6  8  6  4  2  4  8  6  4  6  2  4  6  2  6  6  6  4  6  2  6  4
        2  4  2 10 12  2  4  2 10  2  6  4  2  4  6  6  2 10  2  6  4 14  4  2
        4  2  4  8  6  4  6  2  4  6  2  6  6  4  2  4  6  2  6  4  2  4 12  2))

(defun next (pid)
   (! pid `#(next ,(self)))
   (receive (x x)))

(defun primes ()
   (spawn (MODULE) 'gen '((2 3 5 7 11))))

(defun gen (primes)
   (receive
      (`#(next ,sender)
         (case primes
            ((list p)
               (! sender p)
               (divloop 1 0 (+wheel-2x3x5x7x11+)))
            ((cons p ps)
               (! sender p)
               (gen ps))))))

(defun divloop (n j wheel)
   (receive
      (`#(next ,sender)
         (let [((tuple n' j') (next-prime n j wheel))]
            (! sender n')
            (divloop n' j' wheel)))))

(defun next-prime (n0 j wheel)
   (let [
      (n  (+ n0 (binary:at wheel j)))
      (j' (if (=:= j (- (byte_size wheel) 1))
             0
             (+ j 1)))
      ]
      (if (td-prime? n 1 0 wheel)
         (tuple n j')
         (next-prime n j' wheel))))

(defun td-prime? (n d0 j wheel) ; 2,3,5,7,11 does not divide n
   (let [(d (+ d0 (binary:at wheel j)))]
      (cond
         ((> (* d d) n)
            'true)
         ((=:= 0 (rem n d))
            'false)
         (else
            (td-prime?
               n
               d
               (if (=:= j (- (byte_size wheel) 1)) 0 (+ j 1))
               wheel)))))
