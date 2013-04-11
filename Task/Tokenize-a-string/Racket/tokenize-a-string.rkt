#lang racket

(for ([s (regexp-split #rx"," "Hello,How,Are,You,Today")])
  (printf "~a." s))
(newline)
