#lang racket
(define (% a b) (- a (* b (truncate (/ a b)))))

(define (bearing- bearing heading)
  (- (% (+ (% (- bearing heading) 360) 540) 360) 180))

(module+ main
  (bearing- 20 45)
  (bearing- -45 45)
  (bearing- -85 90)
  (bearing- -95 90)
  (bearing- -45 125)
  (bearing- -45 145)
  (bearing- 29.4803 -88.6381)
  (bearing- -78.3251 -159.036)

  (bearing- -70099.74233810938 29840.67437876723)
  (bearing- -165313.6666297357 33693.9894517456)
  (bearing- 1174.8380510598456 -154146.66490124757)
  (bearing- 60175.77306795546 42213.07192354373))

(module+ test
  (require rackunit)

  (check-equal? (% 7.5 10) 7.5)
  (check-equal? (% 17.5 10) 7.5)
  (check-equal? (% -7.5 10) -7.5)
  (check-equal? (% -17.5 10) -7.5))
