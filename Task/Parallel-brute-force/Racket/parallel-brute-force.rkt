#lang racket/base
(require racket/place
         racket/list
         racket/match
         ;; requires sha package. install it in DrRacket's "File/Install Package..."
         ;; or with raco:
         ;; % raco pkg install sha
         sha
         (only-in openssl/sha1 hex-string->bytes))

(define (brute css targs)
  (define (sub-work i) (let ((cs (list-ref css i))) (in-range (car cs) (cdr cs))))
  (define-values (as bs cs ds es) (apply values (map sub-work (range 5))))
  (define s (make-bytes 5))
  (for*/list ((a as) #:when (bytes-set! s 0 a)
                     (b bs) #:when (bytes-set! s 1 b)
                     (c cs) #:when (bytes-set! s 2 c)
                     (d ds) #:when (bytes-set! s 3 d)
                     (e es) #:when (bytes-set! s 4 e)
                     (h (in-value (sha256 s)))
                     (t (in-list targs))
                     #:when (bytes=? t h))
    (eprintf "found ~s -> ~s~%" t s)
    (cons (bytes-copy s) t)))

;; ---------------------------------------------------------------------------------------------------
(unless (place-enabled?) (error "We're using places... they're not enabled!"))

(define target-list
  (map hex-string->bytes
       (list "1115dd800feaacefdf481f1f9070374a2a81e27880f187396db67958b207cbad"
             "3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b"
             "74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f")))

(define (run-place/assign-task sub-task)
  (define there (place here
                       (match-define (cons work targs) (place-channel-get here))
                       (place-channel-put here (brute work targs))))
  (place-channel-put there (cons sub-task target-list))
  there)

(define (task->subtasks css n-tasks)
  (match css
    [(list (and initial-range (cons A Z+)) common-tail ...)
     (define step (quotient (+ n-tasks (- Z+ A)) n-tasks))
     (for/list ((a (in-range A Z+ step)))
       ;; replace the head with a sub-task head
       (cons (cons a (min (+ a step) Z+)) common-tail))]))

(define readable-pair (match-lambda [(cons x (app bytes->hex-string s)) (cons x s)]))

(define (parallel-brute css (n-tasks (processor-count)))
  (define the-places (map run-place/assign-task (task->subtasks css n-tasks)))
  (define collected-results (append* (map place-channel-get the-places)))
  (map readable-pair collected-results))

(define 5-char-lowercase-work
  (make-list 5 (cons (char->integer #\a) (add1 (char->integer #\z)))))

;; ---------------------------------------------------------------------------------------------------
(module+ main
  (time (parallel-brute 5-char-lowercase-work)))

;; ---------------------------------------------------------------------------------------------------
(module+ test
  (require rackunit)
  (check-equal?
   (bytes->hex-string (sha256 #"mmmmm"))
   "74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f"
   "SHA-256 works as expected")

  (check-equal?
   (hex-string->bytes "74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f")
   #"t\341\273b\370\332\273\201%\245\210R\266;\337n\256\366g\313V\254\177|\333\246\3270\\P\242/"
   "This is the raw value we'll be hashing to")

  (define m-idx (char->integer #\m))
  (define m-idx+ (add1 m-idx))
  (check-equal?
   (brute (make-list 5 (cons m-idx m-idx+)) target-list)
   (list
    (cons
     #"mmmmm"
     #"t\341\273b\370\332\273\201%\245\210R\266;\337n\256\366g\313V\254\177|\333\246\3270\\P\242/")))

  ;; Brute works without parallelism
  ;; check when you have the time... it takes a minute (literally)
  (check-equal?
   (time
    (brute 5-char-lowercase-work target-list))
   '((#"apple"
      . #":{\323\3426\n=)\356\2446\374\373~D\3075\321\27\304-\34\0305B\vk\231B\335O\e")
     (#"mmmmm"
      .
      #"t\341\273b\370\332\273\201%\245\210R\266;\337n\256\366g\313V\254\177|\333\246\3270\\P\242/")
     (#"zyzzx"
      .
      #"\21\25\335\200\17\352\254\357\337H\37\37\220p7J*\201\342x\200\361\2079m\266yX\262\a\313\255"))
   "without parallelism, it works"))
