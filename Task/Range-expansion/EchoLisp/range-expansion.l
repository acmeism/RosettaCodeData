;; parsing [spaces][-]digit(s)-[-]digit(s)[spaces]
(define R (make-regexp "^ *(\-?\\d+)\-(\-?\\d+) *$" ))

;; the native (range a b) is [a ... b[
;; (range+ a b) is [a ... b]
(define (range+ a b)
	(if (< a b) (range a (1+ b))
	(if (> a b) (range a (1- b) -1)
	(list a))))
	
;; in : string : "number" or "number-number"
;; out : a range = list of integer(s)
(define (do-range str)
(define from-to (regexp-exec R str)) ;; "1-3" --> ("1" "3")
(if from-to
    (range+ (string->number (first from-to)) (string->number (second from-to)))
    (list (string->number str))))

(define (ranges str)
    (apply append (map do-range (string-split str ","))))
	

(define task "-6,-3--1,3-5,7-11,14,15,17-20")
(ranges task)
    → (-6 -3 -2 -1 3 4 5 7 8 9 10 11 14 15 17 18 19 20)
