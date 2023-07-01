(define source (bytes->string (file->bytestream "letter_frequency.scm"))) ; utf-8
(define dict (lfold (lambda (ff char)
                     (put ff char (+ 1 (get ff char 0))))
               {}
               (str-iter source)))
; that's all.

; just print the dictionary in human readable format:
(for-each (lambda (kv)
            (let* ((key value kv))
               (case key
                  (#\newline
                     (display "NEWLINE"))
                  (#\tab
                     (display "TAB"))
                  (#\space
                     (display "SPACE"))
                  ((< key #\space) => (lambda (_)
                     (display "char ") (display key)))
                  (else
                     (display (string key))))
               (display " --> ")
               (display value))
            (print))
   (ff->alist dict))
