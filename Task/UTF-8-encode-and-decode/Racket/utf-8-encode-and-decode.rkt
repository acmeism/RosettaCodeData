#lang racket

(define char-map
  '((LATIN-CAPITAL-LETTER-A              .  #\U0041)
    (LATIN-SMALL-LETTER-O-WITH-DIAERESIS .  #\U00F6)
    (CYRILLIC-CAPITAL-LETTER-ZHE         .  #\U0416)
    (EURO-SIGN                           .  #\U20AC)
    (MUSICAL-SYMBOL-G-CLEF               .  #\U1D11E)))

(for ((name.char (in-list char-map)))
  (define name (car name.char))
  (define chr (cdr name.char))
  (let ((bites (bytes->list (string->bytes/utf-8 (list->string (list chr))))))
    (printf "~s\t~a\t~a\t~a\t~a~%" chr chr
            (map (curryr number->string 16) bites)
            (bytes->string/utf-8 (list->bytes bites))
            name)))
