(lib 'tasks)

(define names #(Aristotle Kant Spinoza Marx Russell))
(define abouts #("Wittgenstein" "the nature of the World" "Kant"  "starving"
    "spaghettis" "the essence of things" "Ω" "📞" "⚽️" "🍅" "🌿"
    "philosophy" "💔"  "👠" "rosetta code" "his to-do list" ))
(define (about) (format "thinking about %a." (vector-ref abouts (random (vector-length abouts)))))

;; statistics
(define rounds (make-vector 5 0))
(define (eat i) (vector-set! rounds i (1+ (vector-ref rounds i))))

;; forks are resources = semaphores
(define (left i) i)
(define (right i) (modulo (1+ i) 5))
(define forks (for/vector ((i 5)) (make-semaphore 1)))
(define (fork i) (vector-ref forks i))

(define laquais (make-semaphore 4))

;; philosophers tasks
(define (philo i)
;; thinking
       (writeln (vector-ref names i) (about))
    (sleep (+ 2000 (random 1000)))
    (wait laquais)
;; get forks
       (writeln (vector-ref names i) 'sitting)
    (wait (fork (left i)))
    (wait (fork (right i)))
       (writeln (vector-ref names i) 'eating)
       (eat i)
       (sleep (+ 6000 (random 1000)))
;; put-forks
    (signal (fork (left i)))
    (signal (fork (right i)))
    (signal laquais)
  i)
(define tasks (for/vector ((i 5)) (make-task philo i)))
