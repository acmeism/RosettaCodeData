;; the reader
(define (read-rules source)
  (with-input-from-string source
    (λ () (for*/list ([line (in-lines)]
                      #:unless (should-be-skipped? line))
            (match line
              [(rx-split A "[[:blank:]]->[[:blank:]][.]" B) (->. A B)]
              [(rx-split A "[[:blank:]]->[[:blank:]]" B)    (->  A B)])))))

;; the new pattern for the match form
(define-match-expander rx-split
  (syntax-rules ()
    [(rx-split A rx B)
     (app (λ (s) (regexp-split (pregexp rx) s)) (list A B))]))

;; skip empty lines and comments
(define (should-be-skipped? line)
  (or (regexp-match? #rx"^#.*" line)
      (regexp-match? #px"^[[:blank:]]*$" line)))

(define (read-Markov-algorithm source)
  (apply Markov-algorithm (read-rules source)))
