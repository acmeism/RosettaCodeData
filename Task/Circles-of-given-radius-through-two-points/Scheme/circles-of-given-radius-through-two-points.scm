(import (scheme base)
        (scheme inexact)
        (scheme write))

;; c1 and c2 are pairs (x y), r a positive radius
(define (find-circles c1 c2 r)
  (define x-coord car) ; for easier to read coordinate extraction from list
  (define y-coord cadr)
  (define (approx= a b) (< (- a b) 0.000001)) ; equal within tolerance
  (define (avg a b) (/ (+ a b) 2))
  (define (distance pt1 pt2)
    (sqrt (+ (square (- (x-coord pt1) (x-coord pt2)))
             (square (- (y-coord pt1) (y-coord pt2))))))
  (define (equal-points? pt1 pt2)
    (and (approx= (x-coord pt1) (x-coord pt2))
         (approx= (y-coord pt1) (y-coord pt2))))
  (define (delete-duplicate pts) ; assume no more than two points in list
    (if (and (= 2 (length pts))
             (equal-points? (car pts) (cadr pts)))
      (list (car pts)) ; keep the first only
      pts))
  ;
  (let ((d (distance c1 c2)))
    (cond ((equal-points? c1 c2) ; coincident points
           (if (> r 0)
             'infinite   ; r > 0
             (list c1))) ; else r = 0
          ((< (* 2 r) d)
           '()) ; circle cannot reach both points, as too far apart
          ((approx= r 0.0) ; r = 0, no circles, as points differ
           '())
          (else ; find up to two circles meeting c1 and c2
            (let* ((mid-pt (list (avg (x-coord c1) (x-coord c2))
                                 (avg (y-coord c1) (y-coord c2))))
                   (offset (sqrt (- (square r)
                                    (square (* 0.5 d)))))
                   (delta-cx (/ (- (x-coord c1) (x-coord c2)) d))
                   (delta-cy (/ (- (y-coord c1) (y-coord c2)) d)))
              (delete-duplicate
                (list (list (- (x-coord mid-pt) (* offset delta-cx))
                            (+ (y-coord mid-pt) (* offset delta-cy)))
                      (list (+ (x-coord mid-pt) (* offset delta-cx))
                            (- (y-coord mid-pt) (* offset delta-cy))))))))))

;; work through the input examples, outputting results
(for-each
  (lambda (c1 c2 r)
    (let ((result (find-circles c1 c2 r)))
      (display "p1: ") (display c1)
      (display " p2: ") (display c2)
      (display " r: ") (display (number->string r))
      (display " => ")
      (cond ((eq? result 'infinite)
             (display "Infinite number of circles"))
            ((null? result)
             (display "No circles"))
            (else
              (display result)))
      (newline)))
  '((0.1234 0.9876) (0.0000 2.0000) (0.1234 0.9876) (0.1234 0.9876) (0.1234 0.9876))
  '((0.8765 0.2345) (0.0000 0.0000) (0.1234 0.9876) (0.8765 0.2345) (0.1234 0.9876))
  '(2.0 1.0 2.0 0.5 0.0))
