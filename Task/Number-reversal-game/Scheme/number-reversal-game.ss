(import (scheme base)
        (scheme read)
        (scheme write)
        (srfi 1)   ; list functions
        (srfi 27)) ; random numbers

(random-source-randomize! default-random-source)

(define (make-randomised-list)
  (let ((vec (apply vector (iota 9 1))))
    (do ((c 0 (+ 1 c)))
      ((and (>= c 20)                            ; at least 20 tries
            (not (apply < (vector->list vec)))) ; ensures list not in order
       (vector->list vec))
      (let* ((i (random-integer 9)) ; swap two randomly chosen elements
             (j (random-integer 9))
             (tmp (vector-ref vec i)))
        (vector-set! vec i (vector-ref vec j))
        (vector-set! vec j tmp)))))

(define (play-game lst plays)
  (define (reverse-first n lst)
    (let-values (((start tail) (split-at lst n)))
                (append (reverse start) tail)))
  ;
  (display "List: ") (display lst) (newline)
  (display "How many numbers should be flipped? ")
  (let* ((flip (string->number (read-line)))
         (new-lst (reverse-first flip lst)))
    (if (apply < new-lst)
      (display (string-append "Finished in "
                              (number->string plays)
                              " attempts\n"))
      (play-game new-lst (+ 1 plays)))))

(play-game (make-randomised-list) 1)
