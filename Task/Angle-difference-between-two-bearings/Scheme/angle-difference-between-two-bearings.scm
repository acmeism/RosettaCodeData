#!r6rs

(import (rnrs base (6))
        (rnrs io simple (6)))

(define (bearing-difference bearing-2 bearing-1)
  (- (mod (+ (mod (- bearing-2 bearing-1)
                  360)
             540)
          360)
     180))

(define (bearing-difference-test)
  (define test-cases
    '((20 45)
      (-45 45)
      (-85 90)
      (-95 90)
      (-45 125)
      (-45 145)
      (29.4803 -88.6381)
      (-78.3251 -159.036)
      (-70099.74233810938 29840.67437876723)
      (-165313.6666297357 33693.9894517456)
      (1174.8380510598456 -154146.66490124757)
      (60175.77306795546 42213.07192354373)))
  (for-each
   (lambda (argument-list)
     (display (apply bearing-difference argument-list))
     (newline))
   test-cases))
