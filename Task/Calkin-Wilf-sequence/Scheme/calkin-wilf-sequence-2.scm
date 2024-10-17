; Create a Calkin-Wilf sequence generator.
(define make-calkin-wilf-gen
  (lambda ()
    (let ((an 1))
      (lambda ()
        (let ((ret an))
          (set! an (/ 1 (+ (* 2 (floor an)) 1 (- an))))
          ret)))))

; Return the position in the Calkin-Wilf sequence of the given rational number.
(define calkin-wilf-position
  (lambda (rat)
    ; Run-length encodes binary value.  Assumes first run is 1's.  Args:  initial value,
    ; starting place value (a power of 2), and list of run lengths (list must be odd length).
    (define encode-list-of-runs
      (lambda (value placeval lstruns)
        ; Encode a single run in a binary value.  Args:  initial value, bit value (0 or 1),
        ; starting place value (a power of 2), number of places (bits) to encode.
        ; Returns multiple values:  the encoded value, and the new place value.
        (define encode-run
          (lambda (value bitval placeval places)
            (if (= places 1)
              (values (+ value (* bitval placeval)) (* 2 placeval))
              (encode-run (+ value (* bitval placeval)) bitval (* 2 placeval) (1- places)))))
        ; Loop through the list of runs two at a time.  If list of length 1, do a final
        ; '1'-bit encode and return the value.  Otherwise, do a '1'-bit then '0'-bit encode,
        ; and recurse to do the next two runs.
        (let-values (((value-1 placeval-1) (encode-run value 1 placeval (car lstruns))))
          (if (= 1 (length lstruns))
            value-1
            (let-values (((value-2 placeval-2) (encode-run value-1 0 placeval-1 (cadr lstruns))))
              (encode-list-of-runs value-2 placeval-2 (cddr lstruns)))))))
    ; Return the run-length binary encoding from the odd-length Calkin-Wilf sequence of the
    ; given rational number.  This is equal to the number's position in the sequence.
    (encode-list-of-runs 0 1 (continued-fraction-list-enforce-odd-length! (rat->cf-list rat)))))
