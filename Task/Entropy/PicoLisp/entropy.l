(scl 8)
(load "@lib/math.l")

(setq LN2 0.693147180559945309417)

(de tabulate-chars (Str)
   (let Map NIL
      (for Ch (chop Str)
         (if (assoc Ch Map)
            (con @ (inc (cdr @)))
            (setq Map (cons (cons Ch 1) Map))))
   Map))

(de entropy (Str)
   (let (
      Sz    (length Str)
      Hist  (tabulate-chars Str)
   )
   (*/
      (sum
         '((Pair)
            (let R (*/ (cdr Pair) 1. Sz)
               (- (*/ R (log R) 1.))))
         Hist)
      1. LN2)))
