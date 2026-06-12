(define (pathfinder)
  (define xp 127)
  (define yp 127)
  (define a 0)
  (define na 0)
  (define f (random 4))
  (define x (make-vector 0))
  (define y (make-vector 0))
  (define e (make-vector 0))
  (define paths #(" ahead" " right" " back" " left"))

  (define (resize-preserve v new-size fill)
    (define old-size (vector-length v))
    (define new-v (make-vector new-size fill))
    (for ([i (in-range (min old-size new-size))])
      (vector-set! new-v i (vector-ref v i)))
    new-v)

  (define (update-e n a)
    (cond
      [(and (= (vector-ref x n) (+ (vector-ref x a) 1))
            (= (vector-ref y n) (vector-ref y a)))
       (vector-set! e (* 4 a) (vector-ref e (+ (* 4 n) 2)))]
      [(and (= (vector-ref x n) (vector-ref x a))
            (= (vector-ref y n) (+ (vector-ref y a) 1)))
       (vector-set! e (+ (* 4 a) 1) (vector-ref e (+ (* 4 n) 3)))]
      [(and (= (vector-ref x n) (- (vector-ref x a) 1))
            (= (vector-ref y n) (vector-ref y a)))
       (vector-set! e (+ (* 4 a) 2) (vector-ref e (* 4 n)))]
      [(and (= (vector-ref x n) (vector-ref x a))
            (= (vector-ref y n) (- (vector-ref y a) 1)))
       (vector-set! e (+ (* 4 a) 3) (vector-ref e (+ (* 4 n) 1)))]))

  ;; main program
  (let loop ()
    (set! a na)
    (for ([i (in-range na)])
      (when (and (= (vector-ref x i) xp) (= (vector-ref y i) yp))
        (set! a i)))

    (when (= a na)
      (set! na (+ na 1))
      (set! x (resize-preserve x na 0))
      (set! y (resize-preserve y na 0))
      (set! e (resize-preserve e (* 4 na) 0))
      (vector-set! x a xp)
      (vector-set! y a yp)

      (for ([i (in-range 4)])
        (vector-set! e (+ (* 4 a) i) (random 2)))

      (for ([n (in-range na)])
        (update-e n a)))

    (display "Paths:")
    (for ([i (in-range 4)])
      (when (= (vector-ref e (+ (* 4 a) (modulo (+ f i) 4))) 1)
        (display (vector-ref paths i))))
    (newline)
    (flush-output)

    (let input-loop ()
      (display "> ")
      (flush-output)
      (define entry (string-downcase (read-line)))
      (define d -1)
      (cond
        [(string=? entry "ahead") (set! d (modulo f 4))]
        [(string=? entry "right") (set! d (modulo (+ f 1) 4))]
        [(string=? entry "back")  (set! d (modulo (+ f 2) 4))]
        [(string=? entry "left")  (set! d (modulo (+ f 3) 4))]
        [(string=? entry "quit")  (exit 0)]
        [else (begin (display "Invalid input.\n") (input-loop))])

      (cond
        [(= d 0) (if (= (vector-ref e (+ (* 4 a) 0)) 1)
                     (begin (set! xp (+ xp 1)) (set! f d))
                     (set! d -1))]
        [(= d 1) (if (= (vector-ref e (+ (* 4 a) 1)) 1)
                     (begin (set! yp (+ yp 1)) (set! f d))
                     (set! d -1))]
        [(= d 2) (if (= (vector-ref e (+ (* 4 a) 2)) 1)
                     (begin (set! xp (- xp 1)) (set! f d))
                     (set! d -1))]
        [(= d 3) (if (= (vector-ref e (+ (* 4 a) 3)) 1)
                     (begin (set! yp (- yp 1)) (set! f d))
                     (set! d -1))])

      (when (= d -1)
        (display "No path.\n")
        (input-loop)))

    (loop)))

(pathfinder)
