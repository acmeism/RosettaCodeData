; checks if all characters in numbers lst1 and lst2 (coverted to lists) are the same

 (define (check_list lst1 lst2)
 ; do checks each car of remaining list for equality with char=?
  (do ((remaining lst1 (cdr remaining))
		(remaining2 lst2 (cdr remaining2))
       (final-val #t (char=? (car remaining) (car remaining2)))
	   )
    ( (or (equal? #f final-val) (null? remaining))
	 (if (equal? #f final-val)
	 #f
	 #t
	 ))
    ))

 ; main function to check
(define (own_pow x)
	(let* (
	     (test x)
		 ; length of x as a string
	     (len (string-length (number->string x)))
		 ; powers of digits
	     (powers (apply + (map (lambda (x) (expt x len)) (map string->number (map string (string->list (number->string x) ))))))
	     ; powers as list of characters
		 (res (string->list (number->string powers)))
	     )
		 ; checks if sum of powers and the number have the same length as strings
	  (if (= len (length (string->list (number->string powers))))
	  ; if true goes to function check_list
	  (if (check_list (string->list (number->string x)) res)
		#t
		#f
	  )
	  #f
	  )
	  )
	)

(define limit 10000000)
; loop from 100 to limit
 (let loop ((i 100))
    (cond ((<= limit i) 'ok)
          (else (if (own_pow i)
		  	(print i)
		  		)
                (loop (+ i 1)))))
