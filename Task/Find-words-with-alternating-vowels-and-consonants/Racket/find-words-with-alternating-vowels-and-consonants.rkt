#lang racket

(define alternating?/re
  (match-lambda
    ((regexp #rx"^[aeiou]?([^aeiou][aeiou])*[^aeiou]?$") #t)
    (_ #f)))

(define/match (vowel? v)
  [((or #\a #\e #\i #\o #\u)) #t]
  [(_) #f])

(define consonant? (negate vowel?))

(define (alternating?/for w)
  (or (string=? "" w)
      (let/ec fail (or (for/fold ((expect-vowel? (consonant? (string-ref w 0))))
                                 ((c (in-string w 1)))
                         (if (eq? (vowel? c) expect-vowel?)
                             (not expect-vowel?)
                             (fail #f)))
                       #t))))

(define (alternating?/loop w)
  (define w-len-- (sub1 (string-length w)))
  (or (negative? w-len--)
      (let loop ((expect-vowel? (consonant? (string-ref w w-len--))) (i w-len--))
        (or (zero? i)
            (let* ((i-- (sub1 i)) (c (string-ref w i--)))
              (and (eq? (vowel? c) expect-vowel?)
                   (loop (not expect-vowel?) i--)))))))

(define (alternating?/letrec w)
  (letrec ((l (string-length w))
           (c (λ (i) (string-ref w i)))
           (vc-alt? (match-lambda
                      [(== l) #t]
                      [(and (app c (? vowel?)) (app add1 i)) (cv-alt? i)]
                      [_ #f]))
           (cv-alt? (match-lambda
                      [(== l) #t]
                      [(and (app c (? consonant?))(app add1 i)) (vc-alt? i)]
                      [_ #f])))
    (or (vc-alt? 0) (cv-alt? 0))))

(define (filtered-word? pred)
  (match-lambda [(and (? pred) (? (λ (w) (> (string-length w) 9)))) #t] [_ #f]))

(define all-words (file->lines "../../data/unixdict.txt"))

(module+ main
  (filter (filtered-word? alternating?/re) all-words))

(module+ test
  (require rackunit)
  (define words/re (filter (filtered-word? alternating?/re) all-words))
  (define words/fold (filter (filtered-word? alternating?/for) all-words))
  (define words/loop (filter (filtered-word? alternating?/loop) all-words))
  (define words/letrec (filter (filtered-word? alternating?/letrec) all-words))

  (check-equal? words/re words/fold)
  (check-equal? words/re words/loop)
  (check-equal? words/re words/letrec))
