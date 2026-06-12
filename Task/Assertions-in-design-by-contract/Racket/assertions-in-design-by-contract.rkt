#lang racket
(require racket/contract)

;; This is the contract we will use.
;; "->"                   It is a function
;; (cons/c real?          That takes a list of at least one real (cons/c x (listof x)) means that an x
;;  (listof real?))       must occur before the rest of the list
;; (or/c zero? positive?) returns a non-negative number (for which there is no simpler contract that I
;;                        know of
(define average-of-absolutes/c
  (-> (cons/c real? (listof real?)) (or/c zero? positive?)))

;; this does what it's meant to
(define/contract (average-of-absolutes num-list)
  average-of-absolutes/c
  (/ (apply + (map abs num-list)) (length num-list)))

;; this will return a non-positive real (which will break the contract)
(define/contract (average-of-absolutes:bad num-list)
  average-of-absolutes/c
  (- (/ (apply + (map abs num-list)) (length num-list))))

(define (show-blame-error blame value message)
  (string-append   "Contract Violation!\n"
                   (format "Guilty Party: ~a\n" (blame-positive blame))
                   (format "Innocent Party: ~a\n" (blame-negative blame))
                   (format "Contracted Value Name: ~a\n" (blame-value blame))
                   (format "Contract Location: ~s\n" (blame-source blame))
                   (format "Contract Name: ~a\n" (blame-contract blame))
                   (format "Offending Value: ~s\n" value)
                   (format "Offense: ~a\n" message)))
(current-blame-format show-blame-error)

(module+ test
  ;; a wrapper to demonstrate blame
  (define-syntax-rule (show-contract-failure body ...)
    (with-handlers [(exn:fail:contract:blame?
                     (lambda (e) (printf "~a~%" (exn-message e))))]
                    (begin body ...)))

  (show-contract-failure (average-of-absolutes '(1 2 3)))
  (show-contract-failure (average-of-absolutes '(-1 -2 3)))

  ;; blame here is assigned to this test script: WE're providing the wrong arguments
  (show-contract-failure (average-of-absolutes 42))
  (show-contract-failure (average-of-absolutes '()))

  ;; blame here is assigned to the function implementation: which is returning a -ve value
  (show-contract-failure (average-of-absolutes:bad '(1 2 3)))
  (show-contract-failure (average-of-absolutes:bad '(-1 -2 3)))

  ;; blame here is assigned to this test script: since WE're providing the wrong arguments, so
  ;; the bad function doesn't have a chance to generate an invalid reply
  (show-contract-failure (average-of-absolutes:bad 42))
  (show-contract-failure (average-of-absolutes:bad '())))
