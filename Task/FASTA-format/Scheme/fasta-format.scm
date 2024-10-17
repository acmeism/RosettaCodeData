(import (scheme base)
        (scheme file)
        (scheme write))

(with-input-from-file ; reads text from named file, one line at a time
  "fasta.txt"
  (lambda ()
    (do ((first-line? #t #f)
         (line (read-line) (read-line)))
      ((eof-object? line) (newline))
      (cond ((char=? #\> (string-ref line 0)) ; found a name
             (unless first-line? ; no newline on first name
               (newline))
             (display (string-copy line 1)) (display ": "))
            (else ; display the string directly
              (display line))))))
