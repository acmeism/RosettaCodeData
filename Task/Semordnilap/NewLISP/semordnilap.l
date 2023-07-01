;;;	Get the words as a list, splitting at newline
(setq data
	(parse (get-url "http://wiki.puzzlers.org/pub/wordlists/unixdict.txt")
	"\n"))
;
;;;	destructive reverse wrapped into a function
(define (get-reverse x) (reverse x))
;
;;;	stack of the results
(setq res '())
;
;;;	Find the semordlinap and put them on the stack
(dolist (x data)
	(let (y (get-reverse x))
		(if (and
			(member y data)			; reverse is a dictionary word
			(!= x y)			; but not a palindrome
			(not (member y res)))		; not already stacked
				(push x res -1))))
;
;;;	Count results
(println "Found " (length res) " pairs.")
(println)
;;;	Show the longest ones
(dolist (x res)
	(if (> (length x) 4) (println x " -- " (get-reverse x))))
