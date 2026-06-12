;;
;; This program is written to run without modification both in Otus
;; Lisp and in any of many Scheme dialects. I assume the presence of
;; "case-lambda", but not of "let-values". The program has worked
;; (without modification) in Otus Lisp 2.4, Guile >= 2.0 (but not in
;; Guile version 1.8), CHICKEN Scheme 5.3.0, Chez Scheme 9.5.8, Gauche
;; Scheme 0.9.12, Ypsilon 0.9.6-update3.
;;
;; Here a quaternion is represented as a linked list of four real
;; numbers. Such a representation probably has the greatest
;; portability between Scheme dialects. However, this representation
;; can be replaced, simply by redefining the procedures "quaternion?",
;; "quaternion-components", "quaternion->list", and "quaternion".
;;

(define (quaternion? q)               ; Can q be used as a quaternion?
  (and (pair? q)
       (let ((a (car q))
             (q (cdr q)))
         (and (real? a) (pair? q)
              (let ((b (car q))
                    (q (cdr q)))
                (and (real? b) (pair? q)
                     (let ((c (car q))
                           (q (cdr q)))
                       (and (real? c) (pair? q)
                            (let ((d (car q))
                                  (q (cdr q)))
                              (and (real? d) (null? q)))))))))))

(define (quaternion-components q)       ; Extract the basis components.
  (let ((a (car q))
        (q (cdr q)))
    (let ((b (car q))
          (q (cdr q)))
      (let ((c (car q))
            (q (cdr q)))
        (let ((d (car q)))
          (values a b c d))))))

(define (quaternion->list q)     ; Get a list of the basis components.
  q)

(define quaternion                      ; Make a quaternion.
  (case-lambda
    ((a b c d)
     ;; Make the quaternion from basis components.
     (list a b c d))
    ((q)
     ;; Make the quaternion from a scalar or from another quaternion.
     ;; WARNING: in the latter case, the quaternion is NOT
     ;; copied. This is not a problem, if you avoid things like
     ;; "set-car!" and "set-cdr!".
     (if (real? q)
         (list q 0 0 0)
         q))))

(define (quaternion-norm q)      ; The euclidean norm of a quaternion.
  (let ((q (quaternion q)))
    (call-with-values (lambda () (quaternion-components q))
      (lambda (a b c d)
        (sqrt (+ (* a a) (* b b) (* c c) (* d d)))))))

(define (quaternion-conjugate q)        ; Conjugate a quaternion.
  (let ((q (quaternion q)))
    (call-with-values (lambda () (quaternion-components q))
      (lambda (a b c d)
        (quaternion a (- b) (- c) (- d))))))

(define quaternion+                     ; Add quaternions.
  (let ((quaternion-add
         (lambda (q1 q2)
           (let ((q1 (quaternion q1))
                 (q2 (quaternion q2)))
             (call-with-values
                 (lambda () (quaternion-components q1))
               (lambda (a1 b1 c1 d1)
                 (call-with-values
                     (lambda () (quaternion-components q2))
                   (lambda (a2 b2 c2 d2)
                     (quaternion (+ a1 a2) (+ b1 b2)
                                 (+ c1 c2) (+ d1 d2))))))))))
    (case-lambda
      (() (quaternion 0))
      ((q . q*)
       (let loop ((accum q)
                  (q* q*))
         (if (pair? q*)
             (loop (quaternion-add accum (car q*)) (cdr q*))
             accum))))))

(define quaternion-                  ; Negate or subtract quaternions.
  (let ((quaternion-sub
         (lambda (q1 q2)
           (let ((q1 (quaternion q1))
                 (q2 (quaternion q2)))
             (call-with-values
                 (lambda () (quaternion-components q1))
               (lambda (a1 b1 c1 d1)
                 (call-with-values
                     (lambda () (quaternion-components q2))
                   (lambda (a2 b2 c2 d2)
                     (quaternion (- a1 a2) (- b1 b2)
                                 (- c1 c2) (- d1 d2))))))))))
    (case-lambda
      ((q)
       (let ((q (quaternion q)))
         (call-with-values (lambda () (quaternion-components q))
           (lambda (a b c d)
             (quaternion (- a) (- b) (- c) (- d))))))
      ((q . q*)
       (let loop ((accum q)
                  (q* q*))
         (if (pair? q*)
             (loop (quaternion-sub accum (car q*)) (cdr q*))
             accum))))))

(define quaternion*                     ; Multiply quaternions.
  (let ((quaternion-mul
         (lambda (q1 q2)
           (let ((q1 (quaternion q1))
                 (q2 (quaternion q2)))
             (call-with-values
                 (lambda () (quaternion-components q1))
               (lambda (a1 b1 c1 d1)
                 (call-with-values
                     (lambda () (quaternion-components q2))
                   (lambda (a2 b2 c2 d2)
                     (quaternion (- (* a1 a2) (* b1 b2)
                                    (* c1 c2) (* d1 d2))
                                 (- (+ (* a1 b2) (* b1 a2) (* c1 d2))
                                    (* d1 c2))
                                 (- (+ (* a1 c2) (* c1 a2) (* d1 b2))
                                    (* b1 d2))
                                 (- (+ (* a1 d2) (* b1 c2) (* d1 a2))
                                    (* c1 b2)))))))))))
    (case-lambda
      (() (quaternion 1))
      ((q . q*)
       (let loop ((accum q)
                  (q* q*))
         (if (pair? q*)
             (loop (quaternion-mul accum (car q*)) (cdr q*))
             accum))))))

(define quaternion=?                    ; Are the quaternions equal?
  (let ((=? (lambda (q1 q2)
              (let ((q1 (quaternion q1))
                    (q2 (quaternion q2)))
                (call-with-values
                    (lambda () (quaternion-components q1))
                  (lambda (a1 b1 c1 d1)
                    (call-with-values
                        (lambda () (quaternion-components q2))
                      (lambda (a2 b2 c2 d2)
                        (and (= a1 a2) (= b1 b2)
                             (= c1 c2) (= d1 d2))))))))))
    (lambda (q . q*)
      (let loop ((q* q*))
        (if (pair? q*)
            (and (=? q (car q*))
                 (loop (cdr q*)))
            #t)))))

(define q (quaternion 1 2 3 4))
(define q1 (quaternion 2 3 4 5))
(define q2 (quaternion 3 4 5 6))
(define r 7)

(display "q = ") (display (quaternion->list q)) (newline)
(display "q1 = ") (display (quaternion->list q1)) (newline)
(display "q2 = ") (display (quaternion->list q2)) (newline)
(display "r = ") (display r) (newline)
(newline)
(display "(quaternion? q) = ") (display (quaternion? q)) (newline)
(display "(quaternion? q1) = ") (display (quaternion? q1)) (newline)
(display "(quaternion? q2) = ") (display (quaternion? q2)) (newline)
(display "(quaternion? r) = ") (display (quaternion? r)) (newline)
(newline)
(display "(quaternion-norm q) = ")
(display (quaternion-norm q)) (newline)
(display "(quaternion-norm q1) = ")
(display (quaternion-norm q1)) (newline)
(display "(quaternion-norm q2) = ")
(display (quaternion-norm q2)) (newline)
(newline)
(display "(quaternion- q) = ")
(display (quaternion->list (quaternion- q))) (newline)
(display "(quaternion- q1 q2) = ")
(display (quaternion->list (quaternion- q1 q2))) (newline)
(display "(quaternion- q q1 q2) = ")
(display (quaternion->list (quaternion- q q1 q2))) (newline)
(newline)
(display "(quaternion-conjugate q) = ")
(display (quaternion->list (quaternion-conjugate q))) (newline)
(newline)
(display "(quaternion+) = ")
(display (quaternion->list (quaternion+))) (newline)
(display "(quaternion+ q) = ")
(display (quaternion->list (quaternion+ q))) (newline)
(display "(quaternion+ r q) = ")
(display (quaternion->list (quaternion+ r q))) (newline)
(display "(quaternion+ q r) = ")
(display (quaternion->list (quaternion+ q r))) (newline)
(display "(quaternion+ q1 q2) = ")
(display (quaternion->list (quaternion+ q1 q2))) (newline)
(display "(quaternion+ q q1 q2) = ")
(display (quaternion->list (quaternion+ q q1 q2))) (newline)
(newline)
(display "(quaternion*) = ")
(display (quaternion->list (quaternion*))) (newline)
(display "(quaternion* q) = ")
(display (quaternion->list (quaternion* q))) (newline)
(display "(quaternion* r q) = ")
(display (quaternion->list (quaternion* r q))) (newline)
(display "(quaternion* q r) = ")
(display (quaternion->list (quaternion* q r))) (newline)
(display "(quaternion* q1 q2) = ")
(display (quaternion->list (quaternion* q1 q2))) (newline)
(display "(quaternion* q q1 q2) = ")
(display (quaternion->list (quaternion* q q1 q2))) (newline)
(newline)
(display "(quaternion=? q) = ")
(display (quaternion=? q)) (newline)
(display "(quaternion=? q q) = ")
(display (quaternion=? q q)) (newline)
(display "(quaternion=? q1 q2) = ")
(display (quaternion=? q1 q2)) (newline)
(display "(quaternion=? q q q) = ")
(display (quaternion=? q q q)) (newline)
(display "(quaternion=? q1 q1 q2) = ")
(display (quaternion=? q1 q1 q2)) (newline)
(newline)
(display "(quaternion* q1 q2) = ")
(display (quaternion->list (quaternion* q1 q2))) (newline)
(display "(quaternion* q2 q1) = ")
(display (quaternion->list (quaternion* q2 q1))) (newline)
(display "(quaternion=? (quaternion* q1 q2)") (newline)
(display "              (quaternion* q2 q1)) = ")
(display (quaternion=? (quaternion* q1 q2)
                       (quaternion* q2 q1))) (newline)
