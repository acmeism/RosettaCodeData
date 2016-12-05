(lib 'math) ;; Σ aka (sigma f(n)  nfrom nto)

(define (f-count  N (times 100000))
    (define count 0)
    (for ((i times))

    ;; new  random f mapping from  0..N-1 to 0..N-1
    ;; (f n) is NOT (random N)
    ;; because each call (f n) must return the same value

    (define f (build-vector N  (lambda(i) (random N))))

    (define hits (make-vector N))
        (define n 0)
        (while (zero? [hits n])
            (++ count)
            (vector+= hits n 1)
            (set! n [f n])))
    (// count times))

(define (f-anal N)
    (Σ  (lambda(i) (// (! N) (! (- N i)) (^  N i))) 1 N))

(decimals 5)
(define (f-print (maxN 21))
	(for ((N (in-range 1 maxN)))
	(define fc (f-count N))
	(define fa (f-anal N))
	(printf  "%3d %10d %10d  %10.2d %%" N fc fa (// (abs (- fa fc)) fc 0.01))))
