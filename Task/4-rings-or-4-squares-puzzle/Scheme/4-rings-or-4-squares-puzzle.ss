(import (scheme base)
        (scheme write)
        (srfi 1))

;; return all combinations of size elements from given set
(define (combinations size set unique?)
  (if (zero? size)
    (list '())
    (let loop ((base-combns (combinations (- size 1) set unique?))
               (results '())
               (items set))
      (cond ((null? base-combns) ; end, as no base-combinations to process
             results)
            ((null? items)       ; check next base-combination
             (loop (cdr base-combns)
                   results
                   set))
            ((and unique?        ; ignore if wanting list unique
                  (member (car items) (car base-combns) =))
             (loop base-combns
                   results
                   (cdr items)))
            (else                ; keep the new combination
              (loop base-combns
                    (cons (cons (car items) (car base-combns))
                          results)
                    (cdr items)))))))

;; checks if all 4 sums are the same
(define (solution? a b c d e f g)
  (= (+ a b)
     (+ b c d)
     (+ d e f)
     (+ f g)))

;; Tasks
(display "Solutions: LOW=1 HIGH=7\n")
(display (filter (lambda (combination) (apply solution? combination))
                 (combinations 7 (iota 7 1) #t))) (newline)

(display "Solutions: LOW=3 HIGH=9\n")
(display (filter (lambda (combination) (apply solution? combination))
                 (combinations 7 (iota 7 3) #t))) (newline)

(display "Solution count: LOW=0 HIGH=9 non-unique\n")
(display (count (lambda (combination) (apply solution? combination))
                (combinations 7 (iota 10 0) #f))) (newline)
