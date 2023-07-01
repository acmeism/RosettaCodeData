(require 'timer)

;; returns an 'object' : (&lamdba; message [values])
;; messages : input, output, sample, inspect
(define (make-active)
		(let [
		(t0 #f) (dt 0)
		(t  0) (Kt 0) ; K(t)
		(S  0) (K  0)]
		(lambda (message . args)
		(case message
			((output) (// S 2))
			((input ) (set! K (car args))  (set! t0 #f))
			((inspect) (printf " Active obj : t0 %v t %v S %v "  t0 t Kt (// S 2 )))
			((sample)
					(when (procedure? K)
;; recved new K : init
					(unless t0
						(set! t0  (first args))
						(set! t 0)
						(set! Kt (K 0)))
						
;; integrate K(t) every time 'sample message is received
					(set! dt (- (first args) t t0)) ;; compute once K(t)
					(set! S (+ S (* dt Kt)))
					(set! t (+ t dt))
					(set! Kt (K t))
					(set! S (+ S (* dt Kt)))))
					
			    (else (error "active:bad message" message))))))
