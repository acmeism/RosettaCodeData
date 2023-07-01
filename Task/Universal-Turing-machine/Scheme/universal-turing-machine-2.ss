;----------------------------------------------------------------------------------------------

; Run specified tests: A caption string, a Turing machine, a list of tests, and options (if
; 'notm present, do not output the Turing Machine definition (otherwise display it); if 'supp
; present, suppress leading/trailing blanks; 'mark present, mark the output tape; if 'supp
; present, suppress leading/trailing blanks; if 'leng present, print only the length of the
; output tape, not the contents of either; if 'show present, show an empty input tape (by
; default empty inputs are not shown)).  A test is a list of: limit count (0 = unlimited),
; #t to log progress, and the input tape.
(define run-tm-tests
  (lambda (caption tm test-lst . opts)
    (printf "~%~a...~%" caption)
    (unless (memq 'notm opts) (printf "~%~a~%" (turing->string tm)))
    (let ((input #f))
      (let loop ((tests test-lst))
        (unless (null? tests)
          (newline)
          (set! input (tape-copy (caddar tests)))
          (let-values (((count accepting output)
                        (turing-run tm (caddar tests) (cadar tests) (caar tests))))
            (if (memq 'leng opts)
              (printf "count  = ~d~%accept = ~a~%output length = ~d~%"
                      count accepting (length output))
              (let ((instr (if (memq 'supp opts)
                               (tape->string input #f (turing-blank tm))
                               (tape->string input #f)))
                    (outstr (if (memq 'supp opts)
                               (tape->string output (if (memq 'mark opts) output #f)
                                                    (turing-blank tm))
                               (tape->string output (if (memq 'mark opts) output #f)))))
                (printf "count  = ~d~%accept = ~a~%" count accepting)
                (when (or (memq 'show opts) (not (tape-empty? input (turing-blank tm))))
                  (printf "input  = ~a~%" instr))
                (printf "output = ~a~%" outstr))))
          (loop (cdr tests)))))))

;----------------------------------------------------------------------------------------------
