;; Recursive version adapted from Clojure
;; Added necessary memoization

(define (levenshtein str1 str2 (cost 0) (rest1 0) (rest2 0) (key null))
(set! key (string-append str1 "|" str2))
(if (get 'mem key) ;; memoized ?
    (get 'mem key)
;; else memoize
(putprop 'mem
  (let [(len1 (string-length str1))
        (len2 (string-length str2))]
    (cond ((zero? len1) len2)
          ((zero? len2) len1)
          (else
          (set! cost (if (= (string-first str1) (string-first str2)) 0 1))
          (set! rest1 (string-rest str1))
          (set! rest2 (string-rest str2))
            (min (1+ (levenshtein rest1 str2))
                 (1+ (levenshtein str1 rest2))
                 (+ cost
                    (levenshtein rest1 rest2 ))))))
    key)))

;; 😛 127 calls with memoization
;; 😰 29737 calls without memoization
(levenshtein "kitten" "sitting") → 3

(levenshtein "rosettacode" "raisethysword") → 8
