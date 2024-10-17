(define (make-queue)
(let ((q (cons '() '())))
(lambda (cmd . arg)
(case cmd
    ((empty?) (null? (car q)))
    ((put) (let ((a (cons (car arg) '())))
        (if (null? (car q))
            (begin (set-car! q a) (set-cdr! q a))
            (begin (set-cdr! (cdr q) a) (set-cdr! q a)))))
    ((get) (if (null? (car q)) 'empty
        (let ((x (caar q)))
            (set-car! q (cdar q))
            (if (null? (car q)) (set-cdr! q '()))
            x)))
))))

(define q (make-queue))
(q 'put 1)
(q 'put 6)
(q 'get)
; 1
(q 'get)
; 6
(q 'get)
; empty
