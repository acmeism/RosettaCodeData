;; to save space and time, we do'nt stringify Ω = 5^4^3^2 ,
;; but directly extract tail and head and number of decimal digits

(lib 'bigint) ;; arbitrary size integers

(define e10000 (expt 10 10000)) ;; 10^10000

(define (last-n big (n 20))
(string-append "..." (number->string (modulo big (expt 10 n)))))

(define (first-n big (n 20))
	(while (> big e10000)
		(set! big (/ big e10000))) ;; cut 10000 digits at a time
	(string-append (take (number->string big) n) "..."))

;; faster than directly using (number-length big)
(define (digits big (digits 0))
	(while (> big e10000)
		(set! big (/ big e10000))
		(set! digits (1+ digits)))
	(+ (* digits 10000) (number-length big)))

(define Ω (expt 5 (expt 4 (expt 3 2))))

(last-n Ω )
    → "...92256259918212890625"
(first-n Ω )
    → "62060698786608744707..."
(digits Ω )
    → 183231
