;;;	Get the words as a list, splitting at newline
(setq data
	(parse (get-url "http://wiki.puzzlers.org/pub/wordlists/unixdict.txt")
	"\n"))
;
;;;	Replace each word with a list of its key (list of sorted chars) and itself
;;;	For example "hello" –> (("e" "h" "l" "l" "o") "hello")
(setq data (map (fn(x) (list (sort (explode x)) x)) data))
;
;;;	Sort on the keys (data is modified); (x 0) is the same as (first x)
(sort data (fn(x y) (> (x 0)(y 0))))
;
;;;	Return a list of lists of words with the same key
;;;	An empty list at the head is inconsequential
(define (group-by-key)
	(let (temp '() res '() oldkey '())
		(dolist (x data)
			(if (= (x 0) oldkey)
				(push (x 1) temp)
				(begin
					(push temp res)
					(setq temp (list (x 1)) oldkey (x 0)))))
		(push temp res)
		res))
;
;;;	Print out only groups of more than 4 words
(map println (filter (fn(x) (> (length x) 4)) (group-by-key)))
