;; starting the program
(define (start)
  (displayln "Combine given four numbers using operations + - * / to get 24.")
  (displayln "Input 'q' to quit or your answer like '1 - 3 * (2 + 3)'")
  (new-game))

;; starting a new game
(define (new-game)
  ;; create a new number set
  (define numbers (build-list 4 (λ (_) (+ 1 (random 9)))))
  (apply printf "Your numbers: ~a  ~a  ~a  ~a\n" numbers)
  (new-input numbers))

;; processing a new user input
(define (new-input numbers)
  ;; if an exception is raized while processing, show the exeption message
  ;; and prompt for another input, but do not stop the program.
  (with-handlers ([exn? (λ (exn)
                          (displayln (exn-message exn))
                          (new-input numbers))])
    ;; get the answer
    (define user-expr (read-the-answer))
    ;; interprete it
    (case user-expr
      [(q) (display "Good buy!")]
      [(n) (new-game)]
      [else (define ans (interprete user-expr numbers))
            (case ans
              [(24) (printf "Indeed! ~a = 24\n" user-expr)
                    (new-game)]
              [else (error "Wrong!" user-expr '= ans)])])))

;; reading and preparing the user's answer
;; "1 + 2 * (3 + 4)" --> '(1 + 2 * (3 + 4))
(define (read-the-answer)
  (read (open-input-string (format "(~a)" (read-line)))))
