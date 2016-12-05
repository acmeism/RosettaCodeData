(define ack
  0 N -> (+ N 1)
  M 0 -> (ack (- M 1) 1)
  M N -> (ack (- M 1)
              (ack M (- N 1))))
