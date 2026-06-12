(require (for-syntax racket))

(define-sequence-syntax in-permutations-with-repetitions
  (lambda () #'permutations-with-repetitions/proc)
  (lambda (stx)
    (syntax-case stx ()
      [[(element) (_  size/ex items/ex)]
       #'[(element)
          (:do-in ([(size) size/ex]
                   [(items) items/ex]
                   [(items-vector) (list->vector items/ex)]
                   [(num) (length items/ex)]
                   [(last-pos) (make-vector size/ex (sub1 (length items/ex)))])
                  (void)
                  ([pos (make-vector size 0)])
                  #t
                  ([(element) (reverse
                               (for/list ([p (in-vector pos)])
                                (vector-ref items-vector p)))])
                  #t
                  (not (equal? pos last-pos))
                  [(let ([ret (make-vector size #f)])
                     (for/fold ([carry 1]) ((i (in-range size)))
                       (let ([tmp (+ (vector-ref pos i) carry)])
                         (if (= tmp num)
                           (begin
                             (vector-set! ret i 0)
                             #;carry 1)
                           (begin
                             (vector-set! ret i tmp)
                             #;carry 0))))
                     ret)])]])))


(for/list ([element (in-permutations-with-repetitions 2 '(1 2 3))])
  element)
(sequence->list (in-permutations-with-repetitions 2 '(1 2 3)))
