#lang racket
(define t 5)     ; total number of threads
(define count 0) ; number of threads arrived at rendezvous
(define mutex      (make-semaphore 1)) ; exclusive access to count
(define turnstile  (make-semaphore 0))
(define turnstile2 (make-semaphore 1))
(define ch (make-channel))

(define (make-producer name start)
  (λ ()
    (let loop ([n start])
      (sleep (* 0.01 (random 10))) ; "compute" something
      ;; rendezvous
      (semaphore-wait mutex)
      (set! count (+ count 1)) ; we have arrived
      (when (= count t) ; are we the last to arrive?
        (semaphore-wait turnstile2)
        (semaphore-post turnstile))
      (semaphore-post mutex)
      ; avoid deadlock problem:
      (semaphore-wait turnstile)
      (semaphore-post turnstile)
      ; critical point
      (channel-put ch n) ; send result to controller
      ; leave properly
      (semaphore-wait mutex)
      (set! count (- count 1))
      (when (= count 0) ; are we the last to leave?
        (semaphore-wait turnstile)
        (semaphore-post turnstile2))
      (semaphore-post mutex)

      (semaphore-wait turnstile2)
      (semaphore-post turnstile2)

      (loop (+ n t)))))

; start t workers:
(map (λ(start) (thread (make-producer start start)))
     (range 0 t))

(let loop ()
  (displayln (for/list ([_ t]) (channel-get ch)))
  (loop))
