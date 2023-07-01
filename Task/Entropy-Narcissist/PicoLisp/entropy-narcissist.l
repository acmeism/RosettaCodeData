(scl 8)
(load "@lib/math.l")

(setq LN2 0.693147180559945309417)

(setq Me
   (let F (file)
      (pack (car F) (cadr F))))

(setq Hist NIL Sz 0)
(in Me
   (use Ch
      (while (setq Ch (rd 1))
         (inc 'Sz)
         (if (assoc Ch Hist)
            (con @ (inc (cdr @)))
            (setq Hist (cons (cons Ch 1) Hist))))))

(prinl "My entropy is "
   (format
      (*/
         (sum
            '((Pair)
               (let R (*/ (cdr Pair) 1. Sz)
                  (- (*/ R (log R) 1.))))
            Hist)
         1. LN2)
      *Scl))

(bye)
