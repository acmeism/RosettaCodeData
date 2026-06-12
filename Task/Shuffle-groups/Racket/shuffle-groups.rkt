#lang racket

(define (make-shuffle-group base size witnesses)
  (list base size witnesses))

(define (group-base sg)      (car sg))
(define (group-size sg)      (cadr sg))
(define (group-witnesses sg) (caddr sg))

(define (sorted-digits-desc n)
  (list->string
   (sort (string->list (number->string n)) char>?)))

(define (shuffle n l)
  (let ((s (sorted-digits-desc n)))
    (if (= 0 (modulo n 10))
        #f
        (let loop ((i 2) (witnesses '()))
          (cond
           [(> i 9)
            (if (null? witnesses)
                #f
                (make-shuffle-group n (+ 1 (length witnesses)) witnesses))]
           [else
            (let ((m (* n i)))
              (cond
               [(> m l)
                (if (null? witnesses)
                    #f
                    (make-shuffle-group n (+ 1 (length witnesses)) witnesses))]
               [(string=? s (sorted-digits-desc m))
                (loop (+ i 1) (cons i witnesses))]
               [else (loop (+ i 1) witnesses)]))])))))

(define (generate-shuffle-groups needed)
  (let loop-e ((e 3) (found 0) (current-n 1000) (groups '()))
    (if (>= found needed)
        (reverse groups)
        (let ((l (* 5 (expt 10 (+ e 1)))))
          (let loop-n ((n current-n) (found found) (groups groups))
            (if (or (>= found needed) (> n (* 5 (expt 10 e))))
                (loop-e (+ e 1) found (+ n 1) groups)
                (let ((result (shuffle n l)))
                  (if result
                      (loop-n (+ n 1) (+ found 1) (cons result groups))
                      (loop-n (+ n 1) found groups)))))))))

(define (pad-left str ancho)
  (let ((len (string-length str)))
    (if (<= len ancho)
        (string-append (make-string (- ancho len) #\space) str)
        str)))

(define (print-group-tabular idx sg)
  (let* ((base (group-base sg))
         (idx-pad (pad-left (~a idx) 4))
         (base-pad (pad-left (~a base) 9)))
    (printf "~a ~a " idx-pad base-pad)
    (for-each (lambda (w) (printf " ~a" w)) (group-witnesses sg))
    (newline)))

(define (print-header)
  (printf " index  number  group\n"))

(define (count-by-witnesses up-to groups)
  (let ((counts (make-vector 9 0)))
    (let loop ((i 0))
      (if (> i up-to)
          counts
          (let ((sg (list-ref groups i)))
            (let ((w (- (group-size sg) 1)))
              (when (and (<= 1 w 8))
                (vector-set! counts w (+ 1 (vector-ref counts w)))))
            (loop (+ i 1)))))))

(define (print-stats up-to groups)
  (let ((counts (count-by-witnesses up-to groups)))
    (printf "\nFor the first ~a shuffle groups, there are:\n" (add1 up-to))
    (let loop ((w 1))
      (if (> w 8)
          'done
          (let ((c (vector-ref counts w)))
            (when (> c 0)
              (printf " ~a with ~a witness" (~a c) (~a w))
              (unless (= w 1) (display "es"))
              (newline))
            (loop (+ w 1)))))))

;; Main program
(define (main)
  ;; first 20
  (printf "First twenty shuffle groups\n")
  (print-header)
  (let ((groups (generate-shuffle-groups 20)))
    (let loop ((i 0))
      (if (= i 20)
          'done
          (begin
            (print-group-tabular i (list-ref groups i))
            (loop (+ i 1))))))

  ;; >4 witnesses
  (printf "\nFirst shuffle group with more than 4 witnesses\n")
  (print-header)
  (let ((groups (generate-shuffle-groups 145)))
    (print-group-tabular 144 (list-ref groups 144))
    (print-stats 144 groups))

  ;; exactly 3 witnesses
  (printf "\nFirst shuffle group with exactly 3 witnesses\n")
  (print-header)
  (let ((groups (generate-shuffle-groups 809)))
    (print-group-tabular 808 (list-ref groups 808))
    (print-stats 808 groups))

  ;; exactly 4 witnesses
  (printf "\nFirst shuffle group with exactly 4 witnesses\n")
  (print-header)
  (let ((groups (generate-shuffle-groups 126853)))
    (print-group-tabular 126852 (list-ref groups 126852))
    (print-stats 126852 groups)))

(main)
