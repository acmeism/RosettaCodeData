(lib 'struct)
(lib 'sql)
(lib 'words)

(lib 'dico.fr.no-accent) ;; load dictionary
(string-delimiter "")

;; check reverse r of w is a word
;; take only one pair : r < w
(define (semordnilap? w)
	    (define r (list->string (reverse (string->list w))))
	    (and (word? r) (string<? r w)))
	
;; to get longest first
(define (string-sort a b) (> (string-length a) (string-length b)))
	
(define (task)
;; select unique words into the list 'mots'
    (define mots (make-set (words-select #:any null 999999)))
    (define semordnilap
	    (list-sort string-sort (for/list ((w mots))
	    #:when (semordnilap? w)
	    w )))
   (writeln 'pairs '→ (length semordnilap))
   (writeln 'longest '→ (take semordnilap 5)))
