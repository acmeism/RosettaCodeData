(define INC
  (Turing-Machine #:start 'q0
    [q0 1 1 right q0]
    [q0 () 1 stay qf]))
