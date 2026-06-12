(define (alist-ref key alist)
  (cond
    ((null? alist) #f)
    ((eq? (caar alist) key) (cdar alist))
    (else (alist-ref key (cdr alist)))))

(define (nktg x v m dmDt)
  (let* ((p (* m v))
         (nktg1 (* x p))
         (nktg2 (* dmDt p))
         (tendency1
           (cond
             ((> nktg1 0) "Moving away from stable state")
             ((< nktg1 0) "Moving toward stable state")
             (else "Stable equilibrium")))
         (tendency2
           (cond
             ((> nktg2 0) "Mass variation supports movement")
             ((< nktg2 0) "Mass variation resists movement")
             (else "No mass variation effect"))))
    `((p . ,p)
      (NKTg1 . ,nktg1)
      (NKTg2 . ,nktg2)
      (Tendency1 . ,tendency1)
      (Tendency2 . ,tendency2))))

;; Example
(define r (nktg 2 3 4 -0.5))

(display "p        = ") (display (alist-ref 'p r)) (newline)
(display "NKTg1    = ") (display (alist-ref 'NKTg1 r)) (newline)
(display "NKTg2    = ") (display (alist-ref 'NKTg2 r)) (newline)
(display "Tendency1= ") (display (alist-ref 'Tendency1 r)) (newline)
(display "Tendency2= ") (display (alist-ref 'Tendency2 r)) (newline)
