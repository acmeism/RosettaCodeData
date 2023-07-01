(lib 'list) ;; list-delete

(define BLOCKS '("BO" "XK" "DQ" "CP" "NA" "GT" "RE" "TG" "QD" "FS"
	     "JW" "HU" "VI" "AN" "OB" "ER" "FS" "LY" "PC" "ZM" ))
	
(define WORDS '("A" "BARK" "BOOK" "TREAT" "COMMON" "SQUAD" "CONFUSE"))
	
(define (spell word blocks)
    (cond
	((string-empty? word) #t)
	((empty? blocks) #f)
	(else
	(for/or [(block blocks)]
		#:continue (not (string-match block (string-first word)))
		(spell (string-rest word) (list-delete blocks block))))))
				
