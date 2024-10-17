; Primality test by simple trial division.
(define prime?
  (lambda (num)
    (if (< num 2)
      #f
      (let loop ((div 2))
        (cond ((> (* div div) num) #t)
              ((zero? (modulo num div)) #f)
              (else (loop (1+ div))))))))

; Check if number is an emirp prime.
(define emirp?
  (lambda (num)
    (and (prime? num)
         (let ((rev (string->number (list->string (reverse (string->list (number->string num)))))))
           (and (not (= num rev)) (prime? rev))))))

(printf "The first 20 emirps:")
(do ((num 1 (1+ num)) (cnt 0))
    ((>= cnt 20))
  (when (emirp? num)
    (set! cnt (1+ cnt))
    (printf " ~d" num)))
(newline)

(printf "All emirps between 7700 and 8000:")
(do ((num 7700 (1+ num)))
    ((>= num 8000))
  (when (emirp? num)
    (printf " ~d" num)))
(newline)

(printf "The 10000th emirp: ~d~%"
        (do ((num 1 (1+ num)) (cnt 0))
            ((>= cnt 10000) (1- num))
          (when (emirp? num) (set! cnt (1+ cnt)))))
