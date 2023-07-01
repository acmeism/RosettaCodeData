#|Loops while reading and collecting characters from STDIN until EOF (C-Z or C-D)
Then concatenates the characters into a string|#
(format t
  (concatenate 'string
    (loop for x = (read-char *query-io*) until (or (char= x #\Sub) (char= x #\Eot)) collecting x)))
