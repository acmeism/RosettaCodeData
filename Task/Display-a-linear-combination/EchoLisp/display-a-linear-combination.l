;; build an html string from list of coeffs

(define (linear->html coeffs)
    (define plus #f)
    (or*
    (for/fold (html "") ((a coeffs) (i (in-naturals 1)))
      (unless (zero? a)
 		(set! plus (if plus "+" "")))
      (string-append html
	 (cond
	  ((= a 1)  (format "%a e<sub>%d</sub> " plus i))
	  ((= a -1) (format "- e<sub>%d</sub> " i))
	  ((> a 0)  (format "%a %d*e<sub>%d</sub> " plus a i))
	  ((< a 0)  (format "- %d*e<sub>%d</sub> " (abs a) i))
	  (else ""))))
     "0"))
	
(define linears '((1 2 3)
   (0 1 2 3)
   (1 0 3 4)
   (1 2 0)
   (0 0 0)
   (0)
   (1 1 1)
   (-1 -1 -1)
   (-1 -2 0 -3)
   (-1)))

(define (task linears)
    (html-print ;; send string to stdout
    (for/string ((linear linears))
      (format "%a -> <span style='color:blue'>%a</span> <br>" linear (linear->html linear)))))
