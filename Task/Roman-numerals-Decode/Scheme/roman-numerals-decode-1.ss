(use gauche.collection) ;; for fold2

(define (char-val char)
  (define i (string-scan "IVXLCDM" char))
  (* (expt 10 (div i 2)) (expt 5 (mod i 2))))

(define (decode roman)
  (fold2
    (lambda (n sum prev-val)
      (values ((if (< n prev-val) - +) sum n) (max n prev-val)))
    0 0
    (map char-val (reverse (string->list roman)))))
