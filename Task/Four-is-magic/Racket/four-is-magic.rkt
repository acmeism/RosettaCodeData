#lang racket

(require rackunit)

(define smalls
  (map symbol->string
       '(zero one two three four five six seven eight nine ten eleven twelve
         thirteen fourteen fifteen sixteen seventeen eighteen nineteen)))

(define tens
  (map symbol->string
       '(zero ten twenty thirty forty fifty sixty seventy eighty ninety)))

(define larges
  (map symbol->string
       '(thousand million billion trillion quadrillion quintillion sextillion
         septillion octillion nonillion decillion undecillion duodecillion
         tredecillion quattuordecillion quindecillion sexdecillion
         septendecillion octodecillion novemdecillion vigintillion)))

(define (number->words n)
  (define (step div suffix separator [subformat number->words])
    (define-values [q r] (quotient/remainder n div))
    (define S (if suffix (~a (subformat q) " " suffix) (subformat q)))
    (if (zero? r) S (~a S separator (number->words r))))
  (cond [(< n 0) (~a "negative " (number->words (- n)))]
        [(< n 20) (list-ref smalls n)]
        [(< n 100) (step 10 #f "-" (curry list-ref tens))]
        [(< n 1000) (step 100 "hundred" " ")]
        [else (let loop ([N 1000000] [D 1000] [unit larges])
                (cond [(null? unit)
                       (error 'number->words "number too big: ~e" n)]
                      [(< n N) (step D (car unit) " ")]
                      [else (loop (* 1000 N) (* 1000 D) (cdr unit))]))]))

(define (first-cap s)
  (~a (string-upcase (substring s 0 1)) (substring s 1)))

(define (magic word [acc null])
  (if (equal? word "four")
      (string-join (reverse (cons "four is magic." acc)) ", \n")
      (let* ([word-len (string-length word)]
             [words (number->words word-len)])
        (magic words
               (cons (string-append word " is " words) acc)))))

(define (number-magic n)
  (first-cap (magic (number->words n))))

(for ([n (append (range 11)
                 '(-10 23 172 20140 100 130 999999 876000000
                       874143425855745733896030))])
  (displayln n)
  (displayln (number-magic n))
  (newline))
