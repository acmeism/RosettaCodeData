(define ranks
  (quote (ace 2 3 4 5 6 7 8 9 10 jack queen king)))

(define suits
  (quote (clubs diamonds hearts spades)))

(define new-deck
  (apply append
         (map (lambda (suit)
                (map (lambda (rank)
                       (cons rank suit))
                     ranks))
              suits)))

(define (shuffle deck)
  (define (remove-card deck index)
    (if (zero? index)
        (cdr deck)
        (cons (car deck) (remove-card (cdr deck) (- index 1)))))
  (if (null? deck)
      (list)
      (let ((index (random (length deck))))
        (cons (list-ref deck index) (shuffle (remove-card deck index))))))

(define-syntax deal!
  (syntax-rules ()
    ((deal! deck hand)
     (begin (set! hand (cons (car deck) hand)) (set! deck (cdr deck))))))
