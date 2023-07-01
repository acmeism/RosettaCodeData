#lang racket
(define (cents-* x y)
  (/ (round (* 100 x y)) 100))

(struct item (name count price))

(define (string-pad-right len . strs)
  (define all (apply string-append strs))
  (string-append  all (make-string (- len (string-length all)) #\space)))

(define (string-pad-left len . strs)
  (define all (apply string-append strs))
  (string-append  (make-string (- len (string-length all)) #\space) all))

(define (show-formated name count price total)
  (printf "~a ~a ~a -> ~a\n"
          (string-pad-right 10 name)
          (string-pad-left 18 count)
          (string-pad-left 8 price)
          (string-pad-left 23 total)
          ))

(define (show-item it)
  (show-formated (item-name it)
                 (~r (item-count it))
                 (string-append "$" (~r (item-price it) #:precision '(= 2)))
                 (string-append "$" (~r (cents-* (item-count it) (item-price it)) #:precision '(= 2)))
          ))

(define (show-total all tax-rate)
  (define net (for/sum ([it (in-list all)])
                       (cents-* (item-count it) (item-price it))))
  (define tax (cents-* net tax-rate))
  (show-formated "" "" "net" (string-append "$" (~r net #:precision '(= 2))))
  (show-formated "" "" "tax" (string-append "$" (~r tax #:precision '(= 2))))
  (show-formated "" "" "total" (string-append "$" (~r (+ net tax) #:precision '(= 2))))
  )

(define hamburger (item "hamburger" 4000000000000000 #e5.50))
(define milkshake (item "milkshake" 2 #e2.86))
(define all (list hamburger milkshake))

(for-each show-item all)
(newline)
(show-total all (/ #e7.65 100))
