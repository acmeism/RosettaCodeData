#lang racket

(define render-phrases pretty-print)

(define dict-1 (list "a" "bc" "abc" "cd" "b"))
(define dict-2 (list "mobile" "samsung" "sam" "sung" "man" "mango"
                     "icecream" "and" "go" "i" "like" "ice" "cream"))

(define (word-splits str d)
  (let ((memo (make-hash)))
    (let inr ((s str))
      (hash-ref! memo s
                 (λ () (append* (filter-map (λ (w)
                                              (and (string-prefix? s w)
                                                   (if (string=? w s)
                                                       (list s)
                                                       (map (λ (tl) (string-append w " " tl))
                                                            (inr (substring s (string-length w)))))))
                                            d)))))))

(module+ main
  (render-phrases (word-splits "abcd" dict-1))
  (render-phrases (word-splits "abbc" dict-1))
  (render-phrases (word-splits "abcbcd" dict-1))
  (render-phrases (word-splits "acdbc" dict-1))
  (render-phrases (word-splits "abcdd" dict-1))
  (render-phrases (word-splits "ilikesamsung" dict-2))
  (render-phrases (word-splits "iii" dict-2))
  (render-phrases (word-splits "ilikelikeimangoiii" dict-2))
  (render-phrases (word-splits "samsungandmango" dict-2))
  (render-phrases (word-splits "samsungandmangok" dict-2))
  (render-phrases (word-splits "ksamsungandmango" dict-2)))
