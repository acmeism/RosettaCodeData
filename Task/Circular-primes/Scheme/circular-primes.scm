(import srfi-1)

; rotate list by n
(define (rotate lst n)
  (if (> n 0)
    (append (drop lst n) (take lst n))
    (append (take-right lst (abs n)) (drop-right lst (abs n)))))


; prime check
(define (prime? n)
  (if (< n 4) (> n 1)
      (and (odd? n)
	   (let loop ((k 3))
	     (or (> (* k k) n)
		 (and (positive? (remainder n k))
		      (loop (+ k 2))))))))

; returns number rotated in lists
(define (circ_lists lst)
  (let
  (
    (len (length lst))
  )
  (do (
       (remaining 1 (+ 1 remaining))
       (circs '() (cons (rotate lst remaining) circs ))
       )
      ((< len remaining) circs)
    )

  )
)

; helper function to make number a list to rotate it
(define (number->list x)
  (string->list (number->string x))
)

; returns list to number
(define (list->number x)
  (string->number (list->string x))
)

; checks if number is prime when the number is turned into lists
(define (check x)
   (not (member #f (map prime? (map list->number (circ_lists (number->list x))))))
 )

; all permutations of a number
(define (perms x)
 (map list->number (circ_lists (number->list x)))
)

(define limit 19)

; checks if all permutations of x are not in lst
(define (not_perm x lst)
  (equal? '() (filter-map (lambda (x) (not (equal? #f x)))
    (map (lambda (x) (member x lst)) (perms x))))
  )


(define (circular_primes x lst)
  (cond
  (
   (< (length lst) limit)
      ; if is true if all permutations are prime and if all permutations are not already in the lst, which is returned
      (if (and (equal? #t (check x)) (equal? #t (not_perm x lst)))
        (circular_primes (+ x 1) (cons x  lst))
        (circular_primes (+ x 1) lst)
      )
  )
  (
    lst
  )
  )
 )

(display (reverse (circular_primes 2 '())))

(newline)
