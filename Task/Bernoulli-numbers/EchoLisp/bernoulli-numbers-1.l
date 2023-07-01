(lib 'bigint) ;; lerge numbers
(lib 'gloops) ;; classes

(define-class Rational null ((a :initform #0) (b :initform #1)))
(define-method tostring  (Rational) (lambda (r) (format "%50d / %d" r.a r.b)))
(define-method normalize (Rational) (lambda (r) ;; divide a and b by gcd
		 (let ((g (gcd r.a r.b)))
		 (set! r.a (/ r.a g)) (set! r.b (/ r.b g))
 		 (when (< r.b 0) (set! r.a ( - r.a)) (set! r.b (- r.b))) ;; denominator > 0
 		r)))
			
(define-method initialize (Rational) (lambda (r) (normalize r)))
(define-method add (Rational) (lambda (r n)  ;; + Rational any number
			(normalize (Rational (+ (* (+ #0 n) r.b) r.a) r.b))))
(define-method add (Rational Rational) (lambda (r q) ;;; + Rational Rational
			(normalize (Rational (+ (* r.a q.b) (* r.b q.a)) (* r.b q.b)))))
(define-method sub (Rational Rational) (lambda (r q)
			(normalize (Rational (- (* r.a q.b) (* r.b q.a)) (* r.b q.b)))))
(define-method mul (Rational Rational) (lambda (r q)
			(normalize (Rational  (* r.a q.a)  (* r.b q.b)))))
(define-method mul (Rational) (lambda (r n)
			(normalize (Rational  (* r.a (+ #0 n))  r.b ))))
(define-method div (Rational Rational) (lambda (r q)
			(normalize (Rational  (* r.a q.b)  (* r.b q.a)))))
