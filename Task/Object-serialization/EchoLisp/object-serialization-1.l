(define (person->string self) (format "%a : person." (person-name self)))
(define (writer->string self) (format "%a:  writer of %a."
            (person-name self)
            (writer-books self)))
(define  (father->string self) (format "%a: father of %a."
            (person-name self)
            (map person-name (father-children self))))

; 'classes' definition, with inheritance.
; a writer is a person, too.
(struct person (name)  #:tostring person->string)
(struct writer person (books) #:tostring writer->string)
(struct father person (children)  #:tostring father->string)

(define simon (writer "Simon" '(my-life my-wife my-bike)))
(define elvis (person "Elvis"))
(define papa (father "papa" (list simon elvis)))

(local-put-value 'simon simon "objects.dat")
📕 local-db: local-put:unknown store : "objects.dat"
;; forgot to create the store. Create it :
(local-make-store "objects.dat") → "objects.dat"

(local-put-value 'simon simon "objects.dat")
(local-put-value 'elvis elvis "objects.dat")
(local-put-value 'papa papa   "objects.dat")

;; inspect
simon → Simon: writer of (my-life my-wife my-bike).
papa → papa: father of (Simon Elvis).
elvis → Elvis : person.
