(declare scm.sqrt [number --> number])

(tc +)

(define mean
  { (list number) --> number }
  Xs -> (/ (sum Xs) (length Xs)))

(define square
  { number --> number }
  X -> (* X X))

(define rms
  { (list number) --> number }
  Xs -> (scm.sqrt (mean (map (function square) Xs))))

(define iota-h
  { number --> number --> (list number) }
  X X -> [X]
  X Lim -> (cons X (iota-h (+ X 1) Lim)))

(define iota
  { number --> (list number) }
  Lim -> (iota-h 1 Lim))

(output "~A~%" (rms (iota 10)))
