#lang racket

;; CYK parser implementation. Returns true if W is valid under R rules.

;; Helper functions for table manipulation
(define (make-table n)
  "Initialize the parsing table with empty sets"
  (make-immutable-hash
   (for*/list ([i (in-range 1 (+ n 1))]
               [j (in-range 1 (+ n 1))])
     (cons (cons i j) (set)))))

(define (get-cell table i j)
  "Get the set at position (i, j) in the table"
  (hash-ref table (cons i j) (set)))

(define (add-to-cell table i j element)
  "Add an element to the set at position (i, j)"
  (hash-set table
            (cons i j)
            (set-add (get-cell table i j) element)))

;; Grammar rule checking
(define (has-terminal-rule? rules word)
  "Check if rules contain a terminal production for word"
  (ormap (lambda (rule)
           (and (= (length rule) 1)
                (equal? (first rule) word)))
         rules))

(define (add-terminals rules word j table)
  "Add terminal productions to table"
  (for/fold ([acc table])
            ([(lhs rule-list) (in-hash rules)])
    (if (has-terminal-rule? rule-list word)
        (add-to-cell acc j j lhs)
        acc)))

;; Rule checking for non-terminals
(define (check-rule lhs rule i j k table)
  "Check a single rule for a split point"
  (if (= (length rule) 2)
      (let* ([rhs1 (first rule)]
             [rhs2 (second rule)]
             [left-cell (get-cell table i k)]
             [right-cell (get-cell table (+ k 1) j)])
        (if (and (set-member? left-cell rhs1)
                 (set-member? right-cell rhs2))
            (add-to-cell table i j lhs)
            table))
      table))

(define (check-rules lhs rules i j k table)
  "Check all rules for a given lhs symbol"
  (for/fold ([acc table])
            ([rule (in-list rules)])
    (check-rule lhs rule i j k acc)))

(define (check-all-rules rules i j k table)
  "Check all grammar rules for a split point"
  (for/fold ([acc table])
            ([(lhs rule-list) (in-hash rules)])
    (check-rules lhs rule-list i j k acc)))

;; Split point iteration
(define (fill-splits rules i j k max-k table)
  "Try all split points k from i to j-1"
  (if (> k max-k)
      table
      (let ([new-table (check-all-rules rules i j k table)])
        (fill-splits rules i j (+ k 1) max-k new-table))))

;; Backward diagonal filling
(define (fill-backward rules i j table)
  "Fill backward diagonally from position j"
  (if (< i 1)
      table
      (let ([new-table (fill-splits rules i j i (- j 1) table)])
        (fill-backward rules (- i 1) j new-table))))

;; Column filling
(define (fill-columns words rules n j table)
  "Fill columns of the parsing table"
  (if (> j n)
      table
      (let* ([word (list-ref words (- j 1))]
             [table1 (add-terminals rules word j table)]
             [table2 (fill-backward rules j j table1)])
        (fill-columns words rules n (+ j 1) table2))))

;; Main CYK parsing function
(define (cyk-parse words rules)
  "Main CYK parsing function. Returns true if words is valid under rules."
  (let* ([n (length words)]
         [table (make-table n)]
         [final-table (fill-columns words rules n 1 table)]
         [result-set (get-cell final-table 1 n)])
    (set-member? result-set "NP")))

;; Test function
(define (main)
  "Test the CYK parser with a sample grammar and input string"
  (define rules
    (hash "NP" '(("Det" "Nom"))
          "Nom" '(("AP" "Nom")
                  ("book")
                  ("orange")
                  ("man"))
          "AP" '(("Adv" "A")
                 ("heavy")
                 ("orange")
                 ("tall"))
          "Det" '(("a"))
          "Adv" '(("very") ("extremely"))
          "A" '(("heavy")
                ("orange")
                ("tall")
                ("muscular"))))

  (define words (string-split "a very heavy orange book" " "))
  (define result (cyk-parse words rules))
  ;;(printf "CYK Parse Result: ~a\n" result)
  result)

;; Run the test
(main)
