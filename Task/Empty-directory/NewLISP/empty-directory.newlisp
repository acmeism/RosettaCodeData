(define (empty-dir? path-to-check)
	(empty? (clean (lambda (x) (or (= "." x) (= ".." x))) (directory path-to-check)))
)
