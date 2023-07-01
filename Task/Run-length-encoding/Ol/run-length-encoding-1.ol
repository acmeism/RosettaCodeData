(define (RLE str)
   (define iter (string->list str))
   (let loop ((iter iter) (chr (car iter)) (n 0) (rle '()))
      (cond
         ((null? iter)
            (reverse (cons (cons n chr) rle)))
         ((char=? chr (car iter))
            (loop (cdr iter) chr (+ n 1) rle))
         (else
            (loop (cdr iter) (car iter) 1 (cons (cons n chr) rle))))))

(define (decode rle)
   (apply string-append (map (lambda (p)
      (make-string (car p) (cdr p))) rle)))
