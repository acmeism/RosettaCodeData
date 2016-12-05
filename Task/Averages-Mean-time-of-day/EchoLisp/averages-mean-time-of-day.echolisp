;; string hh:mm:ss to radians
(define (time->radian time)
    (define-values (h m s) (map string->number (string-split time ":")))
    (+  (* h (/ PI 12)) (* m (/ PI 12 60)) (* s (/ PI 12 3600))))
			
;; radians to string hh:mm;ss
(define (radian->time rad)
	(when (< rad 0) (+= rad (* 2 PI)))
	(define t (round (/ (* 12 3600 rad) PI)))
	(define h (quotient t 3600))
	(define m (quotient (- t (* h 3600)) 60))
	(define s (- t (* 3600 h) (* 60 m)))
	(string-join (map number->string (list h m s)) ":"))
	
(define (mean-time times)
	(radian->time
	 (angle
	  (for/sum ((t times)) (make-polar 1 (time->radian t))))))
	
(mean-time '{"23:00:17" "23:40:20" "00:12:45" "00:17:19"})
    →  "23:47:43"
