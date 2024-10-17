(import (scheme base)
        (scheme char)
        (scheme write)
        (srfi 1)    ; lists
        (srfi 132)) ; sorting

(define-record-type <places> ; compound data type is a record with two fields
                    (make-place name population)
                    place?
                    (name place-name)
                    (population place-population))

(define *items*
  (list-sort ; sort by decreasing population
    (lambda (r1 r2) (> (place-population r1)
                       (place-population r2)))
    (list (make-place "Lagos" 21.0)
          (make-place "Cairo" 15.2)
          (make-place "Kinshasa-Brazzaville" 11.3)
          (make-place "Greater Johannesburg" 7.55)
          (make-place "Mogadishu" 5.85)
          (make-place "Khartoum-Omdurman" 4.98)
          (make-place "Dar Es Salaam" 4.7)
          (make-place "Alexandria" 4.58)
          (make-place "Abidjan" 4.4)
          (make-place "Casablanca" 3.98))))

;; Find the (zero-based) index of the first city in the list
;; whose name is "Dar Es Salaam"
(display "Test 1: ")
(display (list-index (lambda (item)
                       (string=? "Dar Es Salaam" (place-name item)))
                     *items*))
(newline)

;; Find the name of the first city in this list
;; whose population is less than 5 million
(display "Test 2: ")
(display (place-name
           (find (lambda (item)
                   (< (place-population item) 5.0))
                 *items*)))
(newline)

;; Find the population of the first city in this list
;; whose name starts with the letter "A"
(display "Test 3: ")
(display (place-population
           (find (lambda (item)
                   (char=? (string-ref (place-name item) 0)
                           #\A))
                 *items*)))
(newline)
