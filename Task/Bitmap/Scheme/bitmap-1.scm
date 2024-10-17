(define (make-list length object)
  (if (= length 0)
      (list)
      (cons object (make-list (- length 1) object))))

(define (list-fill! list object)
  (if (not (null? list))
      (begin (set-car! list object) (list-fill! (cdr list) object))))

(define (list-set! list element object)
  (if (= element 1)
      (set-car! list object)
      (list-set! (cdr list) (- element 1) object)))

(define (list-get list element)
  (if (= element 1)
      (car list)
      (list-get (cdr list) (- element 1))))
