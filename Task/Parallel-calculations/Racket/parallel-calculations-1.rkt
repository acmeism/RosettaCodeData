#lang racket
(require math)
(provide main)

(define (smallest-factor n)
  (list (first (first (factorize n))) n))

(define numbers
  '(112272537195293 112582718962171 112272537095293
    115280098190773 115797840077099 1099726829285419))

(define (main)
  ; create as many instances of Racket as
  ; there are numbers:
  (define ps
    (for/list ([_ numbers])
      (place ch
             (place-channel-put
              ch
              (smallest-factor
               (place-channel-get ch))))))
  ; send the numbers to the instances:
  (map place-channel-put ps numbers)
  ; get the results and find the maximum:
  (argmax first (map place-channel-get ps)))
