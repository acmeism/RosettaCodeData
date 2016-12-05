(lib 'sequences)
(define input-stream null)
(define output-stream "")

;;---------------------------
;; character I/O simulation
;; --------------------------
(define (read-char) (next input-stream)) ;; #f if EOF
(define (write-char c) (when c (set! output-stream (string-append output-stream c))))

(define (init-streams sentence)
	(set! input-stream (procrastinator sentence))
	(set! output-stream ""))

;;---------------------------------
;; task , using read-char/write-char
;;----------------------------------

(define (flop) ; reverses,  and returns first non-alpha after word, or EOF
	(define c (read-char))
	(if (string-alphabetic? c) (begin0 (flop) (write-char c)) c))
	
(define (flip)
    (define c (read-char))
    (if (string-alphabetic? c) (begin (write-char c)  (flip)) c))

(define (task sentence)
	 (init-streams sentence)
	 (while (and (write-char (flip)) (write-char (flop))))
	 output-stream )
