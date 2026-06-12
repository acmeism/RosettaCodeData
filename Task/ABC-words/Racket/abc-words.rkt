#lang racket

(for ((i (in-naturals 1))
      (w (filter (curry regexp-match #rx"^[^bc]*a[^c]*b.*c.*$")
          (file->lines "../../data/unixdict.txt"))))
  (printf "~a\t~a~%" i w))
