#lang racket
(let loop ([m #t])
  (when m
    (when (regexp-try-match #rx"^>" (current-input-port))
      (unless (eq? #t m) (newline))
      (printf "~a: " (read-line)))
    (loop (regexp-match #rx"\n" (current-input-port) 0 #f
                        (current-output-port)))))
(newline)
