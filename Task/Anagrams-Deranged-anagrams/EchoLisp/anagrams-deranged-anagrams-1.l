(lib 'hash)
(lib 'struct)
(lib 'sql)
(lib 'words)


(define H (make-hash))

(define (deranged w1 w2)
	(for ((a w1) (b w2))
		#:break (string=? a b) => #f
		#t))

(define (anagrams (normal) (name) (twins))
(for ((w *words*))
	(set! name (word-name w))
	(set! normal (list->string (list-sort string<? (string->list name))))
	(set! twins (or (hash-ref H normal) null))
	#:continue (member name twins)
	#:when  (or (null? twins)  (for/or ((anagram twins)) (deranged name anagram)))
	(hash-set H normal (cons name twins))))
		

(define (task (lmin 8))
(anagrams)
(for ((lw (hash-values H))) ;; lw = list of words
	#:continue (= (length lw) 1)
	#:continue (< (string-length (first lw)) lmin)
	(set! lmin (string-length (first lw)))
	(write lmin) (for-each write lw)
	(writeln)))
