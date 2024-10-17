(define (fps+ . llists)
  (apply lap + llists))

(define (fps- . llists)
  (apply lap - llists))

(define (fps* . llists)
  (define (*fps* p q)
    (let ((larp (lar p)) (larq (lar q)) (ldrp (ldr p)) (ldrq (ldr q)))
      (lons (* larp larq)
            (fps+ (lap (lambda (p) (* p larp)) ldrq)
                  (lap (lambda (p) (* p larq)) ldrp)
                  (lons 0 (*fps* ldrp ldrq))))))
  (cond ((null? llists) (lons 1 (repeat 0)))
        ((null? (cdr llists)) (car llists))
        (else
         (apply fps* (cons (*fps* (car llists) (cadr llists)) (cddr llists))))))

(define (fps/ n . llists)
  (define (*fps/ n d)
    (let ((q (/ (lar n) (lar d))))
      (lons q (*fps/ (fps- (ldr n) (lap (lambda (p) (* p q)) (ldr d))) d))))
  (if (null? llists)
      (*fps/ (lons 1 (repeat 0)) n)
      (*fps/ n (apply fps* llists))))

(define (fpsint llist)
  (lons 0 (lap * llist (lap / (iota 1)))))

(define (fpsdif llist)
  (lap * (iota 1) (ldr llist)))
