(use srfi-13);;Syntax for module inclusion depends on implementation,
;;a sort function may be predefined, or available through srfi 95
(define (mypred? a b)
  (let ((len-a (string-length a))
	(len-b (string-length b)))
    (if (= len-a len-b)
	(string>? (string-downcase b) (string-downcase a))
        (> len-a len-b))))

(sort '("sorted" "here" "strings" "sample" "Some" "are" "be" "to") mypred?)
