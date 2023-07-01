(define (shuffle tp)
   (let ((items (vm:cast tp (type tp)))) ; make a copy
      (for-each (lambda (i)
            (let ((a (ref items i))
                  (j (+ 1 (rand! i))))
               (set-ref! items i (ref items j))
               (set-ref! items j a)))
         (reverse (iota (size items) 1)))
      items))

(define (list-shuffle tp)
   (map (lambda (i)
         (list-ref tp i))
      (tuple->list
         (shuffle (list->tuple (iota (length tp)))))))
