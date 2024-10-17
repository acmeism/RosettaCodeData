(define (string-top s)
  (if (string=? s "") s (substring s 0 (- (string-length s) 1))))

(define (string-tail s)
  (if (string=? s "") s (substring s 1 (string-length s))))

(define (string-top-tail s)
  (string-tail (string-top s)))
