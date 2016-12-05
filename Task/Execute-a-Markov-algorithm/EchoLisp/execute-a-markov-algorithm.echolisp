;; rule := (pattern replacement [#t terminal])

(define-syntax-rule  (pattern rule) (first rule))
(define-syntax-rule  (repl sule) (second rule))
(define-syntax-rule  (term? rule) (!empty? (cddr rule)))

;; (alpha   .beta )--> (alpha beta #t)
(define (term-rule rule)
        (if (string=? (string-first (repl rule)) ".")
            (list (pattern rule) (string-rest (repl rule)) #t)
            rule ))

;; returns list of rules
(define (parse-rules lines)
    (map term-rule
    (for/list [(line (string-split lines "\n"))]
        #:continue (string=? (string-first line) "#")
        (map string-trim
        (string-split (string-replace line "/\\t/g" " ") " -> ")))))

;; markov machine
(define (markov i-string rules)
    (while
        (for/fold (run #f) ((rule rules))
        #:when (string-index (pattern rule) i-string)
          (set! i-string (string-replace i-string (pattern rule) (repl rule)))
            ;;(writeln rule i-string) ;; uncomment for trace
            #:break (term? rule)  => #f
            #:break #t  => #t ))
    i-string)

(define (task i-string  RS)
    (markov i-string (parse-rules RS)))
