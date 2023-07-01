;; set of input files
(define FILES {T0.txt T1.txt T2.txt})
;; store name for permanent inverted index
(define INVERT "INVERTED-INDEX")

;; get text for each file, and call (action filename text)
(define (map-files action files)
    (for ((file files))
    (file->string action file)))

;; create store
(local-make-store INVERT)

; invert-word : word -> set of files
(define (invert-word word file store)
        (local-put-value word
            (make-set  (cons file (local-get-value word store))) store))

; parse file text and invert each word
(define (invert-text file text)
        (writeln 'Inverting file text)
        (let ((text (text-parse text)))
        (for ((word text))  (invert-word (string-downcase word) file INVERT))))
