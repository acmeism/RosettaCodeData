#lang racket

;; inspired by Kotlin

(define (is-#? c) (char=? c #\#))

(define left-digits
  (for/hash ((i (in-naturals))
             (c '((#f #f #t #t #f)
                  (#f #t #t #f #f)
                  (#f #t #f #f #t)
                  (#t #t #t #t #f)
                  (#t #f #f #f #t)
                  (#t #t #f #f #f)
                  (#t #f #t #t #t)
                  (#t #t #t #f #t)
                  (#t #t #f #t #t)
                  (#f #f #t #f #t))))
    (values `(#f ,@c #t) i)))

(define right-digits (for/hash (([k v] left-digits)) (values (map not k) v)))

(define (lookup-blocks bits hsh fail)
  (let recur ((bs bits) (r null))
    (if (null? bs)
        (reverse r)
        (let-values (((bs′ tl) (split-at bs 7)))
          (let ((d (hash-ref hsh bs′ (λ () (fail (list 'not-found bs′))))))
            (recur tl (cons d r)))))))

(define (extract-blocks b fail)
  (let*-values
      (((e-l-m-r-e) (map is-#? (string->list (string-trim b))))
       ((_) (unless (= (length e-l-m-r-e) (+ 3 (* 7 6) 5 (* 7 6) 3))
              (fail 'wrong-length)))
       ((e l-m-r-e) (split-at e-l-m-r-e 3))
       ((_) (unless (equal? e '(#t #f #t)) (fail 'left-sentinel)))
       ((l-m-r e) (split-at-right l-m-r-e 3))
       ((_) (unless (equal? e '(#t #f #t)) (fail 'right-sentinel)))
       ((l m-r) (split-at l-m-r 42))
       ((m r) (split-at m-r 5))
       ((_) (unless (equal? m '(#f #t #f #t #f)) (fail 'mid-sentinel))))
    (values l r)))

(define (upc-checksum? ds)
  (zero? (modulo (for/sum ((m (in-cycle '(3 1))) (d ds)) (* m d)) 10)))

(define (lookup-digits l r fail (transform values))
  (let/ec fail-lookups
    (define ds (append (lookup-blocks l left-digits (λ _ (fail-lookups #f)))
                       (lookup-blocks r right-digits (λ _ (fail-lookups #f)))))
    (if (upc-checksum? ds)
        (transform ds)
        (fail (list 'checksum (transform ds))))))

(define (decode-upc barcode upside-down fail)
  (define-values (l r) (extract-blocks barcode fail))
  (or (lookup-digits l r fail)
      (lookup-digits (reverse r) (reverse l) fail upside-down)))

(define (report-upc barcode)
  (displayln (decode-upc barcode
                         (λ (v) (cons 'upside-down v))
                         (λ (e) (format "invalid: ~s" e)))))

(define (UPC)
  (for-each report-upc
            '("         # #   # ##  #  ## #   ## ### ## ### ## #### # # # ## ##  #   #  ##  ## ###  # ##  ## ### #  # #       "
              "        # # #   ##   ## # #### #   # ## #   ## #   ## # # # ###  # ###  ##  ## ###  # #  ### ###  # # #         "
              "         # #    # # #  ###  #   #    # #  #   #    # # # # ## #   ## #   ## #   ##   # # #### ### ## # #         "
              "       # # ##  ## ##  ##   #  #   #  # ###  # ##  ## # # #   ## ##  #  ### ## ## #   # #### ## #   # #        "
              "         # # ### ## #   ## ## ###  ##  # ##   #   # ## # # ### #  ## ##  #    # ### #  ## ##  #      # #          "
              "          # #  #   # ##  ##  #   #   #  # ##  ##  #   # # # # #### #  ##  # #### #### # #  ##  # #### # #         "
              "         # #  #  ##  ##  # #   ## ##   # ### ## ##   # # # #  #   #   #  #  ### # #    ###  # #  #   # #        "
              "        # # #    # ##  ##   #  # ##  ##  ### #   #  # # # ### ## ## ### ## ### ### ## #  ##  ### ## # #         "
              "         # # ### ##   ## # # #### #   ## # #### # #### # # #   #  # ###  #    # ###  # #    # ###  # # #       "
              "        # # # #### ##   # #### # #   ## ## ### #### # # # #  ### # ###  ###  # # ###  #    # #  ### # #         "
              ; first element again, with corrupted second digit
              "         # #   # ##   # ## #   ## ### ## ### ## #### # # # ## ##  #   #  ##  ## ###  # ##  ## ### #  # #       ")))

(module+ main (UPC))
