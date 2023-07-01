#lang racket
;; Penney's Game. Tim Brown 2014-10-15
(define (flip . _) (match (random 2) (0 "H") (1 "T")))

(define (get-human-sequence) ; no sanity checking here!
  (display "choose your winning sequence of 3 H or T > ")
  (drop-right (drop (string-split (string-upcase (read-line)) "") 1) 1))

(define flips->string (curryr string-join "."))

(define (game-on p1 p2)
  (printf "~a chooses: ~a. ~a chooses: ~a~%"
          (car p1) (flips->string (cdr p1)) (car p2) (flips->string (cdr p2)))
  (match-define (list (list name.1 p1.1 p1.2 p1.3) (list name.2 p2.1 p2.2 p2.3)) (list p1 p2))
  (let turn ((seq null))
    (match seq
      [(list-rest (== p1.3) (== p1.2) (== p1.1) _) name.1]
      [(list-rest (== p2.3) (== p2.2) (== p2.1) _) name.2]
      [else
       (let* ((flp (flip)) (seq+ (cons flp else)))
         (printf "new-flip: ~a -> ~a~%" flp (flips->string (reverse seq+))) (turn seq+))])))

(define (play-game)
  (define-values
    (player-1 player-2)
    (match (flip)
      ["H" (printf "Human chooses first: ")
           (define p1 (cons 'Hom-Sap (get-human-sequence)))
           (values p1 (cons 'Computer
                            (match p1
                              [(list _ f1 (and f2 (app (match-lambda ("H" "T") ("T" "H")) ¬f2)) _)
                               (list ¬f2 f1 f2)])))]
      ["T" (printf "Computer chooses first. ")
           (define p1 (cons 'Computer (build-list 3 flip)))
           (printf "~a chooses: ~a~%" (car p1) (flips->string (cdr p1)))
           (values p1 (cons 'Hom-Sap (get-human-sequence)))]))
  (printf "~a wins!~%" (game-on player-1 player-2)))
