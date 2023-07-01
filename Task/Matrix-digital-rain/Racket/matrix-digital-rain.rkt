#lang racket

(define codes '((Α Π) (Ѐ ѵ) (Ҋ ԯ) (Ϣ ϯ) (ｦ ﾝ) (Ⲁ ⳩) (∀ ∗) (℀ ℺) (⨀ ⫿)))

(define (symbol->integer s) (char->integer (string-ref (symbol->string s) 0)))
(define (pick xs) (list-ref xs (random (length xs))))

(define glyphs
  (map
   integer->char
   (append*
    (for/list ([c (in-list codes)])
      (range (symbol->integer (first c)) (add1 (symbol->integer (second c))))))))

(define palette (vector-append (vector "\e[38;2;255;255;255m")
                               (for/vector ([n (in-range 245 29 -10)])
                                 (format "\e[38;2;0;~a;0m" n))
                               (make-vector 75 "\e[38;2;0;25;0m")))

(match-define (list (app (compose1 sub1 string->number) rows)
                    (app string->number cols))
  (string-split (with-output-to-string (thunk (system "stty size")))))

(define screen (for/vector ([_ (in-range (* rows cols))]) (pick glyphs)))
(define offsets (for/vector ([col cols]) (random (vector-length palette))))

(display "\e[?25l\e[48;5;232m") ; hide the cursor, set the background color

(define (main)
  (for ([iter (in-naturals)])
    (sleep 0.1)
    (display "\e[1;1H") ; reset cursor to top left
    (for ([i (in-range 30)]) (vector-set! screen (random (* rows cols)) (pick glyphs)))
    (for ([i (in-range rows)])
      (for ([j (in-range cols)])
        (display (vector-ref palette (modulo (+ (- i) iter (vector-ref offsets j))
                                             (vector-length palette))))
        (display (vector-ref screen (+ (* cols i) j))))
      (display "\n"))))

(with-handlers ([exn:break? (thunk*
                             ; reset ANSI codes, reshow cursor, clear screen
                             (display "\e[0m")
                             (display "\e[H\e[J\e[?25h"))])
  (main))
