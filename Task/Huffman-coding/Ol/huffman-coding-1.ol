(define phrase "this is an example for huffman encoding")

; prepare initial probabilities table
(define table (ff->list
   (fold (lambda (ff x)
            (put ff x (+ (ff x 0) 1)))
      {}
      (string->runes phrase))))

; just sorter...
(define (resort l)
   (sort (lambda (x y) (< (cdr x) (cdr y))) l))
; ...to sort table
(define table (resort table))

; build huffman tree
(define tree
   (let loop ((table table))
      (if (null? (cdr table))
         (car table)
         (loop (resort (cons
            (cons
               { 1 (car table) 0 (cadr table)}
               (+ (cdar table) (cdadr table)))
            (cddr table)))))))

; huffman codes
(define codes
   (map (lambda (i)
         (call/cc (lambda (return)
            (let loop ((prefix #null) (tree tree))
               (if (ff? (car tree))
                  (begin
                     (loop (cons 0 prefix) ((car tree) 0))
                     (loop (cons 1 prefix) ((car tree) 1)))
                  (if (eq? (car tree) i)
                     (return (reverse prefix))))))))
      (map car table)))
