(defun primep (n)                            ; https://stackoverflow.com/questions/15817350/
  (cond ((= 2 n) t)                          ; Hard-code "2 is a prime"
        ((= 3 n) t)                          ; Hard-code "3 is a prime"
        ((evenp n) nil)                      ; If we're looking at an even now, it's not a prime
        (t                                   ; If it is divisible by an odd number below its square root, it's not prime
	 (do* ((i 3 (incf i 2)))             ; Initialize to 3 and increment by 2 on every loop
	      ((or (> i (isqrt n))           ; Break condition index exceeds its square root
		   (zerop (mod n i)))        ; Break condition it is divisible
	       (not (zerop (mod n i))))))))  ; Returns not divisible, aka prime

(do ((i 42)                                  ; Initialize index to 42
     (c 0))                                  ; Initialize count of primes to 0
    ((= c 42))                               ; Break condition when there are 42 primes
  (incf i)                                   ; Increments index by unity
  (if (primep i)(progn (incf c)              ; If prime increment count of primes
		       (format t "~&~5<~d~;->~>~20<~:d~>" c i) ; Display count of primes found and the prime
		       (incf i (decf i)))))  ; Increment index to previous index plus the prime
