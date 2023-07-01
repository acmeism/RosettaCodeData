(defmodule eratosthenes
   (export (sieve 1)))

(defun sieve (limit)
   (sieve limit (lists:seq 2 limit)))

(defun sieve
   ((limit (= l (cons p _))) (when (> (* p p) limit))
      l)
   ((limit (cons p ns))
      (cons p (sieve limit (remove-multiples p (* p p) ns)))))

(defun remove-multiples (p q l)
   (lists:reverse (remove-multiples p q l '())))

(defun remove-multiples
   ((_ _ '() s) s)
   ((p q (cons q ns) s)
      (remove-multiples p q ns s))
   ((p q (= r (cons a _)) s) (when (> a q))
      (remove-multiples p (+ q p) r s))
   ((p q (cons n ns) s)
      (remove-multiples p q ns (cons n s))))
