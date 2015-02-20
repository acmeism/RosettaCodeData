#lang racket
;; Solve the no connection puzzle. Tim Brown Oct. 2014

;; absolute difference of a and b if they are both true
(define (and- a b) (and a b (abs (- a b))))

;; Finds the differences of all established connections in the network
(define (network-diffs (A #f) (B #f) (C #f) (D #f) (E #f) (F #f) (G #f) (H #f))
  (list (and- A C) (and- A D) (and- A E)
        (and- B D) (and- B E) (and- B F)
        (and- C D) (and- C G)
        (and- D E) (and- D G) (and- D H)
        (and- E F) (and- E G) (and- E H)
        (and- F G)))

;; Make sure there is “no connection” in the network N; return N if good
(define (good-network? N)
  (and (for/and ((d (filter values (apply network-diffs N)))) (> d 1)) N))

;; possible optimisation is to reverse the arguments to network-diffs, reverse the return value from
;; this function and make this a cons but we're pretty quick here as it is.
(define (find-good-network pegs (n/w null))
  (if (null? pegs) n/w
      (for*/or ((p pegs))
        (define n/w+ (append n/w (list p)))
        (and (good-network? n/w+)
             (find-good-network (remove p pegs =) n/w+)))))

(define (render-puzzle pzl)
  (apply printf (regexp-replace* "O" #<<EOS
    O   O
   /|\ /|\
  / | X | \
 /  |/ \|  \
O - O - O - O
 \  |\ /|  /
  \ | X | /
   \|/ \|/
    O   O~%
EOS
                                 "~a") pzl))

(render-puzzle (find-good-network '(1 2 3 4 5 6 7 8)))
