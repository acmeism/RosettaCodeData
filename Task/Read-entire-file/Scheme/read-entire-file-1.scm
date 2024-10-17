(with-input-from-file "foo.txt"
  (lambda ()
    (reverse-list->string
     (let loop ((char (read-char))
                (result '()))
       (if (eof-object? char)
           result
           (loop (read-char) (cons char result)))))))
