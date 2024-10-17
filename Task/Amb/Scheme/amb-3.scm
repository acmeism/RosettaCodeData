;; Gauche needs this:
(use srfi-13) ;; For "string-take-right" & "string-take".

;; Racket would need:
;; (require srfi/13)
;; (require srfi/1)

(define %fail-stack '())

(define (%fail!)
  (if (null? %fail-stack)
      (error 'amb "Backtracking stack exhausted!")
      (let ((backtrack (car %fail-stack)))
        (set! %fail-stack (cdr %fail-stack))
        (backtrack backtrack))))

(define (amb choices)
  (let ((cc (call-with-current-continuation values)))
    (if (null? choices)
        (%fail!)
        (let ((choice (car choices)))
          (set! %fail-stack (cons cc %fail-stack))
          (set! choices (cdr choices))
          choice))))

(define (assert! condition)
  (unless condition (%fail!)))

;;; The list can contain as many lists as desired.
(define words (list '("the" "that" "a")
                    '("frog" "elephant" "thing")
                    '("walked" "treaded" "grows")
                    '("slowly" "quickly")))

(define (joins? a b)
  (equal?
    (string-take-right a 1)
    (string-take b 1)))

(let ((sentence (map amb words)))
  (fold
    (lambda (latest prev)
      (assert! (joins? prev latest))
      latest)
    (car sentence)
    (cdr sentence))
  sentence)
