#lang racket

(let loop ()
  (match (read-char)
    [(? eof-object?) (void)]
    [c (display c)
       (loop)]))
