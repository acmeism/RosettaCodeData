#!/usr/bin/picolisp /usr/lib/picolisp/lib.l

(de hailstone (N)
   (make
      (until (= 1 (link N))
         (setq N
            (if (bit? 1 N)
               (inc (* N 3))
               (/ N 2) ) ) ) ) )

(de hailtest ()
   (let L (hailstone 27)
      (test 112 (length L))
      (test (27 82 41 124) (head 4 L))
      (test (8 4 2 1) (tail 4 L)) )
   (let N (maxi '((N) (length (hailstone N))) (range 1 100000))
      (test 77031 N)
      (test 351 (length (hailstone N))) )
   (println 'OK)
   (bye) )
