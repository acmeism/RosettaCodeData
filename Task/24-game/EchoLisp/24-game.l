(string-delimiter "")
;; check that nums are in expr, and only once
(define (is-valid? expr sorted: nums)
    (when (equal? 'q expr) (error "24-game" "Thx for playing"))
    (unless (and
        (list? expr)
        (equal? nums (list-sort < (filter number? (flatten expr)))))
    (writeln "🎃 Please use" nums)
    #f))

;; 4 random  digits
(define (gen24)
     (->> (append (range 1 10)(range 1 10)) shuffle (take 4) (list-sort < )))

(define (is-24? num)
    (unless (= 24 num)
    (writeln "😧 Sorry - Result = " num)
    #f))

(define (check-24 expr)
    (if (and
        (is-valid? expr nums)
        (is-24?  (js-eval (string expr)))) ;; use js evaluator
        "🍀 🌸 Congrats - (play24) for another one."
        (input-expr check-24 (string nums))))

(define nums null)
(define (play24)
    (set! nums (gen24))
    (writeln "24-game - Can you combine" nums "to get 24 ❓ (q to exit)")
    (input-expr check-24 (string-append  (string nums) " -> 24 ❓")))
