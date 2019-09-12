(define (decompress str)
(let loop ((dc (fold (lambda (f x) ; dictionary (simplest, not optimized), with reversed codes
                        (cons x (cons (list x) f)))
                  '() (iota 256)))
           (w '()) ; output sequence (reversed)
           (s 256) ; maximal dictionary code value + 1
           (x '()) ; current symbols sequence
           (r (str-iter str))); input stream
   (cond
      ((null? r)
         (reverse w))
      ((pair? r)
         (let*((y (cadr (member (car r) dc)))
               (xy (append y x)))
            (if (member xy dc)
               (loop dc (append y w) s xy (cdr r)) ; вряд ли такое будет...
               (loop (cons s (cons xy dc))          ; update dictionary with xy . s
                     (append y w) ; add phrase to output stream
                     (+ s 1)
                     y ; new initial code
                     (cdr r))))) ; next input
      (else
         (loop dc w s x (r))))))

(print (runes->string
   (decompress (runes->string '(84 79 66 69 79 82 78 79 84 256 258 260 265 259 261 263)))))
; => TOBEORNOTTOBEORTOBEEORNOT
