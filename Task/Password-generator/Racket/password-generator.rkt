#lang racket

(require racket/cmdline)

(define valid-uppercase '(#\A #\B #\C #\D #\E #\F #\G #\H #\I #\J
                          #\K #\L #\M #\N #\O #\P #\Q #\R #\S #\T
                          #\U #\V #\W #\X #\Y #\Z))
(define valid-lowercase '(#\a #\b #\c #\d #\e #\f #\g #\h #\i #\j
                          #\k #\l #\m #\n #\o #\p #\q #\r #\s #\t
                          #\u #\v #\w #\x #\y #\z))
(define valid-numbers '(#\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9))
(define valid-symbols '(#\! #\\ #\" #\# #\$ #\% #\& #\' #\( #\)
                        #\* #\+ #\, #\- #\. #\/ #\: #\; #\< #\=
                        #\> #\? #\@ #\[ #\] #\^ #\_ #\{ #\| #\}
                        #\~))

(define visual-invalid '(#\0 #\O #\1 #\I #\l #\| #\5 #\S #\2 #\Z))

(define (is-readable?  c)
  (empty? (filter (lambda (x) (eq? x c)) visual-invalid)))

(define (random-selection lst)
  (list-ref lst (random (length lst))))

(define (generate len readable)
  (let ([upper (if readable (filter is-readable? valid-uppercase) valid-uppercase)]
        [lower (if readable (filter is-readable? valid-lowercase) valid-lowercase)]
        [numbers (if readable (filter is-readable? valid-numbers) valid-numbers)]
        [symbols (if readable (filter is-readable? valid-symbols) valid-symbols)])
    (let loop ([lst (map random-selection (list upper lower numbers symbols))])
      (cond
        [(<= len (length lst)) (shuffle lst)]
        [else (match (random 4)
                [0 (loop (cons (random-selection upper) lst))]
                [1 (loop (cons (random-selection lower) lst))]
                [2 (loop (cons (random-selection numbers) lst))]
                [3 (loop (cons (random-selection symbols) lst))])]))))

(define (run len cnt seed readable)
  (random-seed seed)
  (let loop ([x cnt])
    (unless (zero? x)
      (display (list->string (generate len readable)))
      (newline)
      (loop (- x 1)))))

(define len (make-parameter 10))
(define cnt (make-parameter 1))
(define seed (make-parameter (random 1 1000000)))
(define readable? (make-parameter #f))

(command-line #:program "passwdgen"
              #:once-each
              [("-l" "--length") integer "password length"  (len (string->number integer))]
              [("-c" "--count") integer "number of password" (cnt (string->number integer))]
              [("-s" "--seed") integer "random generator seed" (seed (string->number integer))]
              [("-r" "--readable") "safe characters" (readable? #t)])


(run (len) (cnt) (seed) (readable?))
