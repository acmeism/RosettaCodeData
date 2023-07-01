#lang racket
(module+ test (require tests/eli-tester))
(module+ test
  (test
   (map char->sms-digit (string->list "ABCDEFGHIJKLMNOPQRSTUVWXYZ."))
   => (list 2 2 2 3 3 3 4 4 4 5 5 5 6 6 6 7 7 7 7 8 8 8 9 9 9 9 #f)))

(define char->sms-digit
  (match-lambda
    [(? char-lower-case? (app char-upcase C)) (char->sms-digit C)]
    ;; Digits, too, can be entered on a text pad!
    [(? char-numeric? (app char->integer c)) (- c (char->integer #\0))]
    [(or #\A #\B #\C) 2]
    [(or #\D #\E #\F) 3]
    [(or #\G #\H #\I) 4]
    [(or #\J #\K #\L) 5]
    [(or #\M #\N #\O) 6]
    [(or #\P #\Q #\R #\S) 7]
    [(or #\T #\U #\V) 8]
    [(or #\W #\X #\Y #\Z) 9]
    [_ #f]))

(module+ test
  (test
   (word->textonym "criticisms") => 2748424767
   (word->textonym "Briticisms") => 2748424767
   (= (word->textonym "Briticisms") (word->textonym "criticisms"))))

(define (word->textonym w)
  (for/fold ((n 0)) ((s (sequence-map char->sms-digit (in-string w))) #:final (not s))
    (and s (+ (* n 10) s))))

(module+ test
  (test
   ((cons-uniquely 'a) null) => '(a)
   ((cons-uniquely 'a) '(b)) => '(a b)
   ((cons-uniquely 'a) '(a b c)) => '(a b c)))

(define ((cons-uniquely a) d)
  (if (member a d) d (cons a d)))

(module+ test
  (test
   (with-input-from-string "criticisms" port->textonym#) =>
   (values 1 (hash 2748424767 '("criticisms")))
   (with-input-from-string "criticisms\nBriticisms" port->textonym#) =>
   (values 2 (hash 2748424767 '("Briticisms" "criticisms")))
   (with-input-from-string "oh-no!-dashes" port->textonym#) =>
   (values 0 (hash))))

(define (port->textonym#)
  (for/fold
   ((n 0) (t# (hash)))
   ((w (in-port read-line)))
    (define s (word->textonym w))
    (if s
        (values (+ n 1) (hash-update t# s (cons-uniquely w) null))
        (values n t#))))

(define (report-on-file f-name)
  (define-values (n-words textonym#) (with-input-from-file f-name port->textonym#))

  (define n-textonyms (for/sum ((v (in-hash-values textonym#)) #:when (> (length v) 1)) 1))

  (printf "--- report on ~s ends ---~%" f-name)
  (printf
   #<<EOS
There are ~a words in ~s which can be represented by the digit key mapping.
They require ~a digit combinations to represent them.
~a digit combinations represent Textonyms.

EOS
   n-words f-name (hash-count textonym#) n-textonyms)

  ;; Show all the 6+ textonyms
  (newline)
  (for (((k v) (in-hash textonym#)) #:when (>= (length v) 6)) (printf "~a -> ~s~%" k v))
  (printf "--- report on ~s ends ---~%" f-name))

(module+ main
  (report-on-file "data/unixdict.txt"))
