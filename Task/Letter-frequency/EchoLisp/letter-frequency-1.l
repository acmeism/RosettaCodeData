;; bump count when letter added
(define (hash-counter hash key )
		;; (set! key (string-downcase key)) - if ignore case wanted
		(putprop hash (1+ (or (getprop hash key) 0 )) key))
		
;;  apply to exploded string
;;  and sort result
(define (hash-compare a b) ( < (first a) (first b)))
(define (count-letters hash string)
		(map (curry hash-counter hash) (string->list string))
		(list-sort hash-compare (symbol-plist hash)))
