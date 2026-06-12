#lang racket
(display "Time to wait in seconds: ")
(define time (string->number (read-line)))

(display "File Name: ")
(define file-name (read-line))

(when (file-exists? (string->path (string-append file-name ".mp3")))
  (sleep time)
  (system* "/usr/bin/mpg123" (string-append file-name ".mp3")))
