(define-syntax lons
  (syntax-rules ()
    ((_ lar ldr) (delay (cons lar (delay ldr))))))

(define (lar lons)
  (car (force lons)))

(define (ldr lons)
  (force (cdr (force lons))))

(define (lap proc . llists)
  (lons (apply proc (map lar llists)) (apply lap proc (map ldr llists))))

(define (take n llist)
  (if (zero? n)
      (list)
      (cons (lar llist) (take (- n 1) (ldr llist)))))

(define (iota n)
  (lons n (iota (+ n 1))))

(define (repeat n)
  (lons n (repeat n)))
