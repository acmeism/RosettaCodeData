;; styles -
(style 'td "text-align:right")
(style 'table "border-spacing: 10px;border:1px solid red")
(style 'th "color:blue;")

;; generic html5 builder
;; pushes <tag style=..> (proc content) </tag>
(define  (emit-tag tag html-proc content )
		 (if (style tag)
		 	(push html (format "<%s style='%a'>" tag (style tag)))
		 	(push html (format "<%s>" tag )))
		 (html-proc content)
		 (push html (format "</%s> " tag )))
		
;; html procs : 1 tag, 1 proc
(define (h-raw content)
		(push html (format "%s" content)))
(define (h-header headers)
		(for ((h headers)) (emit-tag 'th h-raw h)))
(define (h-row row)
		(for ((item row)) (emit-tag 'td h-raw item)))
(define (h-table table )
	(emit-tag 'tr h-header (first table))
	;; add row-num  i at head of row
	(for ((i 1000)(row (rest table))) (emit-tag 'tr h-row (cons i row))))
	
