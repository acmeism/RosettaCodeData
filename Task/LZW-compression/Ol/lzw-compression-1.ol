(define (compress str)
(let loop ((dc (fold (lambda (f x) ; dictionary (simplest, not optimized), with reversed codes
                        (cons (list x) (cons x f)))
                  '() (iota 256)))
           (w '()) ; output sequence (reversed)
           (s 256) ; maximal dictionary code value + 1
           (x '()) ; current sequence
           (r (str-iter str))); input stream
   (cond
      ((null? r)
         (reverse (cons (cadr (member x dc)) w)))
      ((pair? r)
         (let ((xy (cons (car r) x)))
            (if (member xy dc)
               (loop dc w s xy (cdr r))
               (loop (cons xy (cons s dc))         ; update dictionary with xy . s
                     (cons (cadr (member x dc)) w) ; add code to output stream
                     (+ s 1) ; increase code
                     (list (car r)) ; new current sequence
                     (cdr r))))) ; next input
      (else
         (loop dc w s x (r)))))
)

(print (compress "TOBEORNOTTOBEORTOBEORNOT")) ; => (84 79 66 69 79 82 78 79 84 256 258 260 265 259 261 263)
