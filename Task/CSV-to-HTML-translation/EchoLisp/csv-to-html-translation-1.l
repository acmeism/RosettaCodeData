;; CSV -> LISTS
(define (csv->row line)  (string-split line ","))
(define (csv->table csv) (map  csv->row (string-split csv "\n")))

;; LISTS->HTML
(define html 'html)
(define  (emit-tag tag  html-proc content )
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
	(for ((row (rest table))) (emit-tag 'tr h-row row)))
	
(define (html-dump) (string-join (stack->list html) " "))
	
;; STYLES
(style 'td "text-align:left")
(style 'table "border-spacing: 10px;border:28px ridge orange") ;; special biblical border
(style 'th "color:blue;")
