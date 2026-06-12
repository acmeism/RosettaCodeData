#lang racket

(define words
  '([alliance -624] [archbishop -915] [balm 397] [bonnet 452] [brute 870]
    [centipede -658] [cobol 362] [covariate 590] [departure 952] [deploy 44]
    [diophantine 645] [efferent 54] [elysee -326] [eradicate 376]
    [escritoire 856] [exorcism -983] [fiat 170] [filmy -874] [flatworm 503]
    [gestapo 915] [infra -847] [isis -982] [lindholm 999] [markham 475]
    [mincemeat -880] [moresby 756] [mycenae 183] [plugging -266]
    [smokescreen 423] [speakeasy -745] [vein 813]))

;; Simple brute-force solution to find the smallest subset
(define (nsubsets l n)
  (cond [(zero? n) '(())] [(null? l) '()]
        [else (append (for/list ([l2 (nsubsets (cdr l) (- n 1))])
                        (cons (car l) l2))
                      (nsubsets (cdr l) n))]))
(for*/first ([i (sub1 (length words))] [s (nsubsets words (add1 i))]
             #:when (zero? (apply + (map cadr s))))
  (map car s))
;; => '(archbishop gestapo)

;; Alternative: customize the subsets to ones with zero sum, abort early
;; if we're in a hopeless case (using the fact that weights are <1000)
(define (zero-subsets l)
  (define (loop l len n r sum)
    (cond [(zero? n) (when (zero? sum) (displayln (reverse r)))]
          [(and (pair? l) (<= sum (* 1000 n)))
           (when (< n len) (loop (cdr l) (sub1 len) n r sum))
           (loop (cdr l) (sub1 len) (sub1 n) (cons (caar l) r)
                 (+ (cadar l) sum))]))
  (define len (length l))
  (for ([i (sub1 len)]) (loop l len (add1 i) '() 0)))
(zero-subsets words)
