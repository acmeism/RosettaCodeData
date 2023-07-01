#lang racket

(define input "hi there, how are you today? I'd like to present to you the washing machine 9001. You have been nominated to win one of these! Just make sure you don't break it")

(define sentence-types #hash((#\. . "S") (#\? . "Q") (#\! . "E")))
(define punctuation (hash-keys sentence-types))

(let ([characters (string->list input)])
  (for ([i characters])
    (when (member i punctuation)
      (printf "~a|" (hash-ref sentence-types i))))
  (unless (member (last characters) punctuation)
    (printf "N")))
