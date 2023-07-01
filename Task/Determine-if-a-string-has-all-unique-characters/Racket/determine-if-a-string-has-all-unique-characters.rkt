#lang racket

(define (first-non-unique-element.index seq)
  (let/ec ret
    (for/fold ((es (hash))) ((e seq) (i (in-naturals)))
      (if (hash-has-key? es e) (ret (list e (hash-ref es e) i)) (hash-set es e i)))
    #f))

(define (report-if-a-string-has-all-unique-characters str)
  (printf "~s (length ~a): ~a~%" str (string-length str)
          (match (first-non-unique-element.index str)
            [#f "contains all unique characters"]
            [(list e i i′) (format "has character '~a' (0x~a) at index ~a (first seen at ~a)"
                                   e (number->string (char->integer e) 16) i′ i)])))

(module+ main
  (for-each report-if-a-string-has-all-unique-characters
            (list "" "." "abcABC" "XYZ ZYX"
                  "1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ")))
