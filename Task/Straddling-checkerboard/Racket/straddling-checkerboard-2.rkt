(define (straddling-encode-char char board)
  (or (for/or ([head (in-vector (*straddling-header board))]
                [line (in-vector (*straddling-main board))])
        (let ([pos (vector-member char line)])
          (if pos
              (string-append head (number->string pos))
              #f)))
      ""))

(define (straddle message board)
  (apply string-append
         (map (lambda (char)
                (if (or (equal? char #\space) (equal? char #\/))
                    ""
                    (straddling-encode-char char board)))
              (string->list (string-upcase message)))))


(define (unstraddle message board)
  (define char->string string)
  (define (straddling-decode-char str row)
    (vector-ref (vector-ref (*straddling-main board) row) (string->number str)))
  (list->string
   (reverse
    (let-values ([(row rev-ret)
                  (for/fold ([row #f] ;row to read in multichar codes
                                      ;#f means start of new code
                             [rev-ret '()]) ;result
                            ([str (map char->string (string->list (string-upcase message)))])
                    (if (not row)
                        (let ([pos (vector-member str (*straddling-header board))])
                          (if pos
                              (values pos rev-ret)
                              (values #f (cons (straddling-decode-char str 1) rev-ret))))
                        (let ([decoded (straddling-decode-char str row)])
                          (if (equal? decoded #\/)
                              (values 0 rev-ret)
                              (values #f (cons decoded rev-ret))))))])
      (unless row ;check that last number was not missing
        rev-ret)))))
