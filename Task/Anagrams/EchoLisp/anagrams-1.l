(require 'struct)
(require 'hash)
(require 'sql)
(require 'words)
(require 'dico.fr.no-accent)


(define mots-français (words-select #:any null 999999))
(string-delimiter "")

(define (string-sort str)
	(list->string (list-sort string<?  (string->list str))))
	
(define (ana-sort H words) ;; bump counter for each word
	(for ((w words))
		#:continue (< (string-length w) 4)
		(let [(key (string-sort w))]  (hash-set H key (1+ (hash-ref! H key 0))))))
		
;; input w word
;; output : list of matching words
(define (anagrams w words)
	(set! w (string-sort w))
	(make-set
	(for/list (( ana words))
		#:when (string=? w (string-sort ana))
		ana)))

(define (task words)
(define H (make-hash))
	(ana-sort H words) ;; build counters key= sorted-string, value = count
	(hash-get-keys H   ;; extract max count values
	    (for/fold (hmax 0) ((h H) )
	    #:when (>= (cdr h) hmax)
	    (cdr h))
	))
