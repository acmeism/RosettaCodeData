#lang racket

(define ((prefix-and-suffix-match? len) str)
  (let ((l (string-length str)))
    (and (>= l (* 2 len))
         (string=? (substring str 0 len)
                   (substring str (- l len))))))

(module+ main
  (filter (prefix-and-suffix-match? 3) (file->lines "../../data/unixdict.txt")))
