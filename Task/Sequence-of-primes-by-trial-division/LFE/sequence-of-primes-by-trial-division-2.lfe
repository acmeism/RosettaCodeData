#!/usr/local/bin/lfescript

(defun show-primes (n)
   (show-primes n (tdwheel:primes)))

(defun show-primes
   ((0 _) (io:format "~n"))
   ((n pid)
      (lfe_io:format "~b " (list (tdwheel:next pid)))
      (show-primes (- n 1) pid)))

(defun show-table (limit)
   (io:format "n\tnth prime\n")
   (show-table limit 1 1 (tdwheel:primes)))

(defun show-table (limit k goal pid)
   (cond
      ((> k limit)
         'ok)
      ((=:= k goal)
         (let [(p (tdwheel:next pid))]
            (io:format "~b\t~b\n" (list goal p))
            (show-table limit (+ k 1) (* goal 10) pid)))
      (else
         (tdwheel:next pid) ; discard result
         (show-table limit (+ k 1) goal pid))))

(defun main (_)
   (show-primes 25)
   (show-table 100000))
