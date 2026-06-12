(define (print-text source)
  (cond ((string? source)
         ;; The source is a string.
         (display source))

        ((and (list? source)
              (or (null? source) (string? (car source))))
         ;; The source is a list of strings.
         (for-each display source))

        ((input-port? source)
         ;; The source is a file or similar.
         (do ((s (read-line source) (read-line source)))
             ((eof-object? s))
           (display s)
           (newline)))))

(print-text "Print me.\n")

(print-text '("Print\n" "a list\n" "of strings.\n"))

(call-with-input-file "type_detection-scheme.scm" print-text)
