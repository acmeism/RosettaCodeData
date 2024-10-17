; Create a dynamically resizing vector (a "dynvec").
; Returns a procedure that takes a variable number of arguments:
; 0 : () --> Returns the vector from index 0 through the maximum index set.
; 1 : (inx) --> Returns the value at the given index.
; 2 : (inx val) --> Sets the given value into the given index, and returns the value.

(define make-dynvec
  (lambda (init-size extra-fact init-val)
    (let ((vec (make-vector init-size init-val)) (maxinx -1))
      (lambda args
        (if (null? args)
          (let ((retvec (make-vector (1+ maxinx))))
            (do ((index 0 (1+ index)))
                ((> index maxinx) retvec)
              (vector-set! retvec index (vector-ref vec index))))
          (let ((inx (car args)))
            (when (>= inx (vector-length vec))
              (let ((newvec (make-vector
                              (inexact->exact (ceiling (* extra-fact inx)))
                              init-val)))
                (do ((index 0 (1+ index)))
                    ((>= index (vector-length vec)))
                  (vector-set! newvec index (vector-ref vec index)))
                (set! vec newvec)))
            (when (pair? (cdr args))
              (when (> inx maxinx) (set! maxinx inx))
              (vector-set! vec inx (cadr args)))
            (vector-ref vec inx)))))))

; Generate the Recaman's sequence.
; Generate the terms of Recaman's sequence until the given "stop" procedure
; returns a true value; that returned value becomes the value of this procedure.
; The arguments to the "stop" procedure are:  n, the value of the n'th term,
; #t if that term was seen before, #t if the term was arrived at by addition,
; the Recaman's sequence so far (as a dynvec), and a dynvec of the n's at which
; a value was first seen or #f if not previously seen ("seen1st").

(define recaman-sequence
  (lambda (stop-proc)
    (let ((recaman (make-dynvec 10 2 0))
          (seen1st (make-dynvec 10 2 #f)))
      (do ((n 0 (1+ n)) (done-retval #f))
          (done-retval done-retval)
        (if (= n 0)
          (begin
            (recaman n 0)
            (seen1st 0 n)
            (set! done-retval (stop-proc n 0 #f #f recaman seen1st)))
          (let ((try-sub (- (recaman (1- n)) n)))
            (if (and (> try-sub 0) (not (seen1st try-sub)))
              (begin
                (recaman n try-sub)
                (seen1st try-sub n)
                (set! done-retval (stop-proc n try-sub #f #f recaman seen1st)))
              (let* ((val-add (+ (recaman (1- n)) n)) (seen-prev (seen1st val-add)))
                (recaman n val-add)
                (unless (seen1st val-add) (seen1st val-add n))
                (set! done-retval
                      (stop-proc n val-add seen-prev #t recaman seen1st))))))))))

; Generate and display the first 15 Recaman's numbers.

(printf "First 15 Recaman's numbers: ~a~%"
        (recaman-sequence (lambda (n val seen-prev by-add recaman seen1st)
                            (and (>= n (1- 15)) (recaman)))))

; Find and display the first duplicated Recaman's number.
; The only way to be a duplicate is if the number was arrived
; at by adding 'n' and the number has been seen before.

(let ((dup-n-val-1st
        (recaman-sequence (lambda (n val seen-prev by-add recaman seen1st)
                            (and by-add seen-prev (list n val (seen1st val)))))))
  (printf "First duplicate Recaman's number: a[~a] = a[~a] = ~a~%"
          (caddr dup-n-val-1st) (car dup-n-val-1st) (cadr dup-n-val-1st)))

; Find and display how many terms of the sequence are needed
; for all the integers 0..1000, inclusive, to be generated.

(let* ((all-first 1001)
       (terms-to-gen-all (recaman-sequence
                           (lambda (n val seen-prev by-add recaman seen1st)
                             (do ((inx 0 (1+ inx)))
                                 ((or (>= inx all-first) (not (seen1st inx)))
                                  (and (>= inx all-first) (1+ n))))))))
  (printf
    "Terms of Recaman's sequence to generate all integers 0..~a, inclusive: ~a~%"
    (1- all-first) terms-to-gen-all))
