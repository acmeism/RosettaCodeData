;;;	Using the built-in "bits" function
;;;	For integers up to 9,223,372,036,854,775,807
(map println (map bits '(0 5 50 9000)))
;;;	n > 0, "unlimited" size
(define (big-bits n)
	(let (res "")
		(while (> n 0)
			(push (if (even? n) "0" "1") res)
			(setq n (/ n 2)))
		res))
;;;	Example
(println (big-bits 1234567890123456789012345678901234567890L))
