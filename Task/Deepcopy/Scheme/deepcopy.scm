(define (deep-copy-1 exp)
  ;; basic version that copies an arbitrary tree made up of pairs
  (cond ((pair? exp)
	 (cons (deep-copy-1 (car exp))
	       (deep-copy-1 (cdr exp))))
	;; cases for extra container data types can be
	;; added here, like vectors and so on
	(else ;; atomic objects
	 (if (string? exp)
	     (string-copy exp)
	     exp))))

(define (deep-copy-2 exp)
  (let ((sharing (make-hash-table)))
    (let loop ((exp exp))
      (cond ((pair? exp)
	     (cond ((get-hash-table sharing exp #f)
		    => (lambda (copy)
			 copy))
		   (else
		    (let ((res (cons #f #f)))
		      (put-hash-table! sharing exp res)
		      (set-car! res (loop (car exp)))
		      (set-cdr! res (loop (cdr exp)))
		      res))))
	    (else
	     (if (string? exp)
		 (string-copy exp)
		 exp))))))

(define t1 '(a b c d))
(define t2 (list #f))
(set-car! t2 t2)
(define t2b (list #f))
(set-car! t2b t2b)
(define t3 (list #f #f))
(set-car! t3 t3)
(set-car! (cdr t3) t3)
(define t4 (list t2 t2b))

;> (print-graph #t)
;> (deep-copy-2 t1)
;(a b c d)
;> (deep-copy-2 t2)
;#0=(#0#)
;> (deep-copy-2 t3)
;#0=(#0# #0#)
;> (deep-copy-2 t4)
;(#0=(#0#) #1=(#1#))
