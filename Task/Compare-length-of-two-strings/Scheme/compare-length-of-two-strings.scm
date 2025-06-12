; sorting for chicken
(import (chicken sort))
; may need it in your scheme, when not included
(import srfi-1)
(define a "i am string")
(define b "i am string too")

(string<? a b)


(cond
		(
			(string<? a b)
			(display b )
			(display " with length ")
			(display (string-length b))
			(newline)
			(display a )
			(display " with length ")
			(display (string-length a))
			(newline)
			
		)
		(
			(string<? b a)
			(display a )
			(display " with length ")
			(display (string-length a))
			(newline)
			(display b )
			(display " with length ")
			(display (string-length b))
			(newline)
		)
)
; extra credit
(define strings '("abcd" "123456789" "abcdef" "1234567"))

(define unsorted-length (map string-length strings))
(define sorted-length (sort (map string-length strings) <))

(for-each (lambda (a)
		(display (list-ref strings (- (length unsorted-length) (length (memq a unsorted-length)))))
		(newline)
		)
		sorted-length
		  )
