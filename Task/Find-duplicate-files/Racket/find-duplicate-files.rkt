#lang racket

(struct F (name id size [links #:mutable]))

(require openssl/sha1)
(define (find-duplicate-files path size)
  (define Fs
    (sort
     (fold-files
      (λ(path type acc)
        (define s (and (eq? 'file type) (file-size path)))
        (define i (and s (<= size s) (file-or-directory-identity path)))
        (define ln (and i (findf (λ(x) (equal? i (F-id x))) acc)))
        (when ln (set-F-links! ln (cons (path->string path) (F-links ln))))
        (if (and i (not ln)) (cons (F path i s '()) acc) acc))
      '() path #f)
     > #:key F-size))
  (define (find-duplicates Fs)
    (define t (make-hash))
    (for ([F Fs])
      (define cksum (call-with-input-file (F-name F) sha1))
      (hash-set! t cksum (cons F (hash-ref t cksum '()))))
    (for/list ([(n Fs) (in-hash t)] #:unless (null? (cdr Fs))) Fs))
  (let loop ([Fs Fs])
    (if (null? Fs) '()
        (let-values ([(Fs Rs)
                      (splitf-at Fs (λ(F) (= (F-size F) (F-size (car Fs)))))])
          (append (find-duplicates Fs)
                  (loop Rs))))))

(define (show-duplicates path size)
  (for ([Fs (find-duplicate-files path size)])
    (define (links F)
      (if (null? (F-links F)) ""
          (format " also linked at ~a" (string-join (F-links F) ", "))))
    (printf "~a (~a)~a\n" (F-name (car Fs)) (F-size (car Fs)) (links (car Fs)))
    (for ([F (cdr Fs)]) (printf "  ~a~a\n" (F-name F) (links F)))))

(show-duplicates (find-system-path 'home-dir) 1024)
