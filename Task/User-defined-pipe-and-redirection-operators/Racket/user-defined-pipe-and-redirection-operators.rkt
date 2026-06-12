#lang racket

(module racksh racket

  (require (for-syntax racket/syntax))

  (provide (except-out (all-from-out racket) #%app sort)
           (rename-out [shell-app #%app]))

  (define-syntax (shell-app stx)
    (define (=? x y)
      (eq? (if (syntax? x) (syntax-e x) x) (if (syntax? y) (syntax-e y) y)))
    (define (err msg) (raise-syntax-error 'shell msg stx))
    (define (make-call xs)
      (cond [(null? xs) (err "empty form")]
            [(string? (syntax-e (car xs))) #`(shell #,(car xs) #,@(cdr xs))]
            [(eq? #\{ (syntax-property (car xs) 'paren-shape)) (cons #'void xs)]
            [else xs]))
    (syntax-case stx ()
      [(_ x ...) (eq? #\{ (syntax-property stx 'paren-shape))
       (let loop ([xs (reverse (syntax->list #'(\; x ...)))]
                  [form '()] [thunks '()] [I #f] [O #f] [seq '()])
         (cond [(null? xs) #`(begin #,@seq)]
               [(=? '\; (car xs))
                (loop (cdr xs) '() '() #f #f
                      (if (and (null? form) (null? thunks)) seq
                          (let* ([form (make-call form)]
                                 [r (if (null? thunks) form
                                        #`(pipe (list (λ() #,form) #,@thunks)))]
                                 [r (if I #`(#,@I (λ() #,r)) r)]
                                 [r (if O #`(#,@O (λ() #,r)) r)])
                            (cons r seq))))]
               [(=? '\| (car xs))
                (loop (cdr xs) '() (cons #`(λ() #,(make-call form)) thunks) I O
                      seq)]
               [(or (=? '< (car xs)) (=? '<< (car xs)))
                (cond [(null? form) (err "missing expression after < or <<")]
                      [I (err "duplicate < or << specified")]
                      [else (loop (cdr xs) (cdr form) thunks
                                  (if (=? '< (car xs))
                                    #`(with-input-from-file #,(car form))
                                    #`(with-input-from-string #,(car form)))
                                  O seq)])]
               [(or (=? '> (car xs)) (=? '>> (car xs)))
                (cond [(null? form) (err "missing expression after > or >>")]
                      [O (err "duplicate > or >> specified")]
                      [else (loop (cdr xs) (cdr form) thunks I
                                  #`(with-output-to-file #,(cadr xs) #:exists
                                      '#,(if (=? '> (car xs)) 'truncate 'append))
                                  seq)])]
               [else (loop (cdr xs) (cons (car xs) form) thunks I O seq)]))]
      [(_ x ...) #'(x ...)]))

  (define (pipe thunks)
    (if (null? (cdr thunks)) ((car thunks))
        (let-values ([(I O) (make-pipe)])
          (parameterize ([current-output-port O])
            (thread (λ() (dynamic-wind void (car thunks)
                                       (λ() (close-output-port O))))))
          (parameterize ([current-input-port I]) (pipe (cdr thunks))))))

  (define (shell cmd . args)
    (apply system* (find-executable-path cmd)
           (map (λ(x) (if (string? x) x
                          (with-output-to-string (λ() (display x)))))
                args)))

  ;; implements a common interface of reading a bunch of files; '- means
  ;; stdin; no files means just stdin
  (define (call/files files proc)
    (if (null? files) (proc (current-input-port))
        (let-values ([(I O) (make-pipe)])
          (thread
           (λ() (for ([file (in-list files)])
                  (if (eq? '- file)
                    (copy-port (current-input-port) O)
                    (call-with-input-file file (λ(i) (copy-port i O)))))
                (close-output-port O)))
          (proc I))))

  (define-syntax (define-io stx)
    (syntax-case stx ()
      [(_ (name . xs) E ...)
       (with-syntax ([io-name (format-id #'name "io-~a" #'name)])
         #'(begin (provide (rename-out [io-name name]))
                  (define (io-name . xs) E ...)))]))

  (define-io (echo . xs)
    (for-each display (add-between xs " "))
    (newline))
  (define-io (cat . files)
    (call/files files (λ(I) (copy-port I (current-output-port)))))
  (define-io (sort . files)
    (display-lines (sort (call/files files port->lines) string<?)))
  (define-io (head n . files)
    (call/files files
      (λ(I) (for ([l (in-lines I)] [i (in-range n)]) (displayln l)))))
  (define-io (tail n . files)
    (display-lines (take-right (call/files files port->lines) n)))
  (define-io (grep rx . files)
    (call/files files
      (λ(I) (for ([l (in-lines I)] #:when (regexp-match? rx l)) (displayln l)))))
  (define-io (uniq . files)
    (call/files files
     (λ(I) (let loop ([last #f])
             (define line (read-line I))
             (unless (eof-object? line)
               (unless (equal? line last) (displayln line))
               (loop line))))))
  (define-io (tee file)
    (call-with-output-file file #:exists 'truncate
      (λ(O) (for ([l (in-lines (current-input-port))])
              (displayln l O) (displayln l)))))

  (provide $)
  (define-syntax-rule ($ E ...)
    (with-output-to-string (λ() E ...))))

(module sample (submod ".." racksh)
  {\;
   define file "List_of_computer_scientists.lst" \;
   define aa ($
     {{ head 4 < file \;
        cat file \| grep "ALGOL" \;
        tail 4 < file \;
      } \| sort \| uniq \| tee "the_important_scientists.lst" \| grep "aa"
     }) \;
   echo "Pioneer:" aa}
  )

(require 'sample)
