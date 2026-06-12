; level: list of lists, any except 1 means the cell is empty
; from: start cell in (x . y) mean
; to: destination cell in (x . y) mean
(define (A* level from to)
   (define (hash xy) ; internal hash
      (+ (<< (car xy) 16) (cdr xy)))

   ; "is the cell is empty?"
   (define (floor? x y)
      (let ((line (list-ref level y)))
         (if line (not (eq? (list-ref line x) 1)))))

   (unless (equal? from to) ; search not finished yet
      (let step1 ((n 999) ; maximal count of search steps
                  (c-list-set #empty)
                  (o-list-set (put #empty (hash from)  [from #f  0 0 0])))
         (unless (empty? o-list-set) ; do we have a space to move?
            ; no. let's find cell with minimal const
            (let*((f (ff-fold (lambda (s key value)
                                 (if (< (ref value 5) (car s))
                                    (cons (ref value 5) value)
                                    s))
                        (cons 9999 #f) o-list-set))
                  (xy (ref (cdr f) 1))
                  ; move the cell from "open" to "closed" list
                  (o-list-set (del o-list-set (hash xy)))
                  (c-list-set (put c-list-set (hash xy) (cdr f))))

               ;
               (if (or (eq? n 0)
                       (equal? xy to))
                  (let rev ((xy xy))
                     ; let's unroll the math and return only first step
                     (let*((parent (ref (get c-list-set (hash xy) #f) 2))
                           (parent-of-parent (ref (get c-list-set (hash parent) #f) 2)))
                        (if parent-of-parent (rev parent)
                           (cons
                              (- (car xy) (car parent))
                              (- (cdr xy) (cdr parent))))))

                  (let*((x (car xy))
                        (y (cdr xy))
                        (o-list-set (fold (lambda (n v)
                                       (if (and
                                             (floor? (car v) (cdr v))
                                             (eq? #f (get c-list-set (hash v) #f)))
                                          (let ((G (+ (ref (get c-list-set (hash xy) #f) 3) 1)); G of parent + 1
                                                ; H calculated by "Manhattan method"
                                                (H (* (+ (abs (- (car v) (car to)))
                                                         (abs (- (cdr v) (cdr to))))
                                                      2))
                                                (got (get o-list-set (hash v) #f)))

                                             (if got
                                                (if (< G (ref got 3))
                                                   (put n (hash v)  [v xy  G H (+ G H)])
                                                   n)
                                                (put n (hash v)  [v xy  G H (+ G H)])))
                                          n))
                                       o-list-set (list
                                                      (cons x (- y 1))
                                                      (cons x (+ y 1))
                                                      (cons (- x 1) y)
                                                      (cons (+ x 1) y)))))
                     (step1 (- n 1) c-list-set o-list-set))))))))
