#lang racket/base
(require racket/block racket/pretty racket/port racket/vector)

(pretty-print-columns 20) ; make the matrices look a bit more matrixey

(define (bankers-algorithm p r maxres curr maxclaim)
  (define running? (make-vector p #t))
  (define alloc (for/vector #:length r ((j (in-range r)))
                  (for/sum ((cu_i (in-vector curr))) (vector-ref cu_i j))))
  (printf "Allocated resources:~%~a~%" (pretty-format alloc))
  (define avl (for/vector #:length r ((m (in-vector maxres)) (a (in-vector alloc))) (- m a)))
  (printf "Available resources:~%~a~%~%" (pretty-format avl))

  (define (safe-exec i mc_i cu_i)
    (define exec? (for/and ((a (in-vector avl)) (m (in-vector mc_i)) (c (in-vector cu_i)))
                    (<= (- m c) a)))
    (cond
      [exec?
       (printf "Process ~a is executing~%" (add1 i))
       (vector-set! running? i #f)
       (for ((j (in-range r)) (a (in-vector avl)) (c (in-vector cu_i))) (vector-set! avl j (+ a c)))
       #t]
      [else #f]))

  (let loop ()
    (unless (zero? (vector-count values running?))
      (define safe?
        (for/first ((i (in-range p))
                    (r? (in-vector running?))
                    (mc_i (in-vector maxclaim))
                    (cu_i (in-vector curr))
                    ;; the break condition for this is identical to safe?, so we have no
                    ;; separate break? flag
                    #:when r?
                    #:when (safe-exec i mc_i cu_i))
          #t))
      (cond [safe?
             (printf "The process is in a safe state~%~%Available vector: ~a~%" (pretty-format avl))
             (loop)]
            [else (displayln "The processes are in an unsafe state")]))))


(define (bankers-input)
  (define ((n-vector? type? dims) x) ;; not the world's most efficient implementation!
    (cond [(null? dims) (type? x)]
          [(not (vector? x)) #f]
          [(not (= (car dims) (vector-length x))) #f]
          [else (for/and ((e (in-vector x))) (n-vector? type? (cdr dims)) e)]))

  (define-syntax-rule (prompted-input prompt valid?)
    (block
     (printf "Enter ~a:~%" prompt)
     (define rv (read))
     (pretty-print rv)
     (unless (valid? rv) (raise-argument-error 'prompted-input (format "~a" 'valid?) rv))
     rv))

  (define p (prompted-input "the number of processes" exact-positive-integer?))
  (define r (prompted-input "the number of resources" exact-positive-integer?))
  (define maxres (prompted-input "Claim Vector" (n-vector? exact-positive-integer? (list r))))
  (define curr (prompted-input "Allocated Resource Table"
                               (n-vector? exact-positive-integer? (list p r))))
  (define maxclaim (prompted-input "Maximum Claim Table"
                                   (n-vector? exact-positive-integer? (list p r))))
  (values p r maxres curr maxclaim))

(module+ main
  (with-input-from-string
   #<<EOS
5
4
#(8 5 9 7)
#(#(2 0 1 1)
  #(0 1 2 1)
  #(4 0 0 3)
  #(0 2 1 0)
  #(1 0 3 0))
#(#(3 2 1 4)
  #(0 2 5 2)
  #(5 1 0 5)
  #(1 5 3 0)
  #(3 0 3 3))

EOS
   (λ () (call-with-values bankers-input bankers-algorithm))))
