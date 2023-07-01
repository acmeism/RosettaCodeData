#lang racket

(define current-S-weight (make-parameter 1))
(define current-D-weight (make-parameter 1))
(define current-I-weight (make-parameter 1))

(define bases '(#\A #\C #\G #\T))

(define (fold-sequence seq kons #:finalise (finalise (λ x (apply values x))) . k0s)
  (define (recur seq . ks)
    (if (null? seq)
      (call-with-values (λ () (apply finalise ks)) (λ vs (apply values vs)))
      (call-with-values (λ () (apply kons (car seq) ks)) (λ ks+ (apply recur (cdr seq) ks+)))))
  (apply recur (if (string? seq) (string->list (regexp-replace* #px"[^ACGT]" seq "")) seq) k0s))

(define (sequence->pretty-printed-string seq)
  (define (fmt idx cs-rev) (format "~a: ~a" (~a idx #:width 3 #:align 'right) (list->string (reverse cs-rev))))
  (fold-sequence
    seq
    (λ (b n start-idx lns-rev cs-rev)
       (if (zero? (modulo n 50))
         (values (+ n 1) n (if (pair? cs-rev) (cons (fmt start-idx cs-rev) lns-rev) lns-rev) (cons b null))
         (values (+ n 1) start-idx lns-rev (cons b cs-rev))))
    0 0 null null
    #:finalise (λ (n idx lns-rev cs-rev)
                (string-join (reverse (if (null? cs-rev) lns-rev (cons (fmt idx cs-rev) lns-rev))) "\n"))))

(define (count-bases b as cs gs ts n)
  (values (+ as (if (eq? b #\A) 1 0)) (+ cs (if (eq? b #\C) 1 0)) (+ gs (if (eq? b #\T) 1 0)) (+ ts (if (eq? b #\G) 1 0)) (add1 n)))

(define (report-sequence s)
  (define-values (as cs gs ts n) (fold-sequence s count-bases 0 0 0 0 0))
  (printf "SEQUENCE:~%~a~%" (sequence->pretty-printed-string s))
  (printf "BASE COUNT:~%-----------~%~a~%"
          (string-join (map (λ (c n) (format " ~a :~a" c (~a #:width 4 #:align 'right n))) bases (list as ts cs gs)) "\n"))
  (printf "TOTAL: ~a~%" n))


(define (make-random-sequence-string l)
  (list->string (for/list ((_ l)) (list-ref bases (random 4)))))

(define (weighted-random-call weights-and-functions . args)
  (let loop ((r (random)) (wfs weights-and-functions))
    (if (<= r (car wfs)) (apply (cadr wfs) args) (loop (- r (car wfs)) (cddr wfs)))))

(define (mutate-S s)
  (let ((r (random (string-length s))) (i (string (list-ref bases (random 4)))))
    (printf "Mutate at ~a -> ~a~%" r i)
    (string-append (substring s 0 r) i (substring s (add1 r)))))

(define (mutate-D s)
  (let ((r (random (string-length s))))
    (printf "Delete at ~a~%" r)
    (string-append (substring s 0 r) (substring s (add1 r)))))

(define (mutate-I s)
  (let ((r (random (string-length s))) (i (string (list-ref bases (random 4)))))
    (printf "Insert at ~a -> ~a~%" r i)
    (string-append (substring s 0 r) i (substring s r))))

(define (mutate s)
  (define W (+ (current-S-weight) (current-D-weight) (current-I-weight)))
  (weighted-random-call
    (list (/ (current-S-weight) W) mutate-S (/ (current-D-weight) W) mutate-D (/ (current-I-weight) W) mutate-I)
    s))

(module+
  main
  (define initial-sequence (make-random-sequence-string 200))
  (report-sequence initial-sequence)
  (newline)
  (define s+ (for/fold ((s initial-sequence)) ((_ 10)) (mutate s)))
  (newline)
  (report-sequence s+)
  (newline)
  (define s+d (parameterize ((current-D-weight 5)) (for/fold ((s initial-sequence)) ((_ 10)) (mutate s))))
  (newline)
  (report-sequence s+d))
