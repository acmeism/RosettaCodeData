(use-modules (ice-9 format))

(define (random-choice probs)
  (define choice (random 1.0))
  (define (helper val prob-lis)
    (let ((nval (- val (cadar prob-lis))))
      (if
       (< nval 0)
       (caar prob-lis)
       (helper nval (cdr prob-lis)))))
  (helper choice probs))

(define (add-result result delta table)
  (cond
   ((null? table) (list (list result delta)))
   ((eq? (caar table) result)
    (cons (list result (+ (cadar table) delta)) (cdr table)))
   (#t (cons (car table) (add-result result delta (cdr table))))))

(define (choices trials probs)
  (define (helper trial-num freq-table)
    (if
     (= trial-num trials)
     freq-table
     (helper
      (+ trial-num 1)
      (add-result (random-choice probs) (/ 1 trials) freq-table))))
  (helper 0 '()))

(define (format-results probs results)
  (for-each
   (lambda (x)
     (format
      #t
      "~10a~10,5f~10,5f~%"
      (car x)
      (cadr x)
      (cadr (assoc (car x) results))))
   probs))

(define probs
  '((aleph 1/5) (beth 1/6) (gimel 1/7) (daleth 1/8)
    (he 1/9) (waw 1/10) (zayin 1/11) (heth 1759/27720)))

(format-results probs (choices 1000000 probs))
