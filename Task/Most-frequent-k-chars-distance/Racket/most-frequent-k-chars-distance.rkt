#lang racket

(define (MostFreqKHashing inputString K)
  (define t (make-hash))
  (for ([c (in-string inputString)] [i (in-naturals)])
    (define b (cdr (hash-ref! t c (λ() (cons i (box 0))))))
    (set-box! b (add1 (unbox b))))
  (define l (for/list ([(k v) (in-hash t)]) (list (car v) k (unbox (cdr v)))))
  (map cdr (take (sort (sort l < #:key car) > #:key caddr) K)))

(define (MostFreqKSimilarity inputStr1 inputStr2) ; not strings in this impl.
  (for*/sum ([c1 (in-list inputStr1)] [c2 (in-value (assq (car c1) inputStr2))]
             #:when c2)
    (+ (cadr c1) (cadr c2))))

(define (MostFreqKSDF inputStr1 inputStr2 K maxDistance)
  (- maxDistance (MostFreqKSimilarity (MostFreqKHashing inputStr1 K)
                                      (MostFreqKHashing inputStr2 K))))

(MostFreqKSDF
 "LCLYTHIGRNIYYGSYLYSETWNTGIMLLLITMATAFMGYVLPWGQMSFWGATVITNLFSAIPYIGTNLV"
 "EWIWGGFSVDKATLNRFFAFHFILPFTMVALAGVHLTFLHETGSNNPLGLTSDSDKIPFHPYYTIKDFLG"
 2 100)
;; => 83

;; (Should add more tests, but it looks like there's a bunch of mistakes
;; in the given tests...)
