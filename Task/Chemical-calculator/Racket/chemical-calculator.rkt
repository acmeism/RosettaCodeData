#lang racket

(define table '([H 1.008]
                [C 12.011]
                [O 15.999]
                [Na 22.98976928]
                [S 32.06]
                [Uue 315.0]))

(define (lookup s) (first (dict-ref table s)))

(define (calc s)
  (define toks
    (with-input-from-string (regexp-replaces s '([#px"(\\d+)" " \\1"]
                                                 [#px"([A-Z])" " \\1"]))
      (thunk (sequence->list (in-port)))))

  (let loop ([toks toks])
    (match toks
      ['() 0]
      [(list (? list? sub) (? number? n) toks ...) (+ (* (loop sub) n) (loop toks))]
      [(list (? list? sub) toks ...) (+ (loop sub) (loop toks))]
      [(list sym (? number? n) toks ...) (+ (* (lookup sym) n) (loop toks))]
      [(list sym toks ...) (+ (lookup sym) (loop toks))])))

(define tests '("H"
                "H2"
                "H2O"
                "H2O2"
                "(HO)2"
                "Na2SO4"
                "C6H12"
                "COOH(C(CH3)2)3CH3"
                "C6H4O2(OH)4"
                "C27H46O"
                "Uue"))

(for ([test (in-list tests)])
  (printf "~a: ~a\n"
          (~a test #:align 'right #:min-width 20)
          (~r (calc test) #:precision 3)))
