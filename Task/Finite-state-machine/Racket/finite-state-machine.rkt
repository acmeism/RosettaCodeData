#lang racket

(define states
  '((ready (deposit . waiting)
           (quit . exit))
    (waiting (select . dispense)
             (refund . refunding))
    (dispense (remove . ready))
    (refunding . ready)))

(define (machine states prompt get-action quit)
  (let recur ((state (caar states)))
    (printf "CURRENT STATE: ~a~%" state)
    (if (eq? state 'exit)
        (quit)
        (recur (match (cdr (assoc state states))
                 [(list (and transitions (cons actions _)) ...)
                  (prompt "next action (from: ~a): " actions)
                  (match (assoc (get-action) transitions)
                    [(cons action new-state)
                     (printf "~a -> ~a -> ~a~%" state action new-state)
                     new-state]
                    [#f (printf "invalid action for~%") state])]
                 [auto-state
                  (printf "~a -> ~a~%" state auto-state)
                  auto-state])))))

(module+ main
  (let/ec quit
    (with-input-from-string "deposit select remove deposit refund quit"
      (λ () (machine states void read quit)))))
