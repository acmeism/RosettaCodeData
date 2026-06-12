;;;
;;; Wordle_Comparison in Scheme
;;;
;;; See Rosetta Code task "Wordle Comparison"
;;; This code is R5RS compliant but requires the addition of "|"
;;; symbol quoting from R7RS to allow all characters from "!" to "~"
;;;
;;; Invoke Gauche:
;;; gosh wordle_comparison.scm
;;; Invoke Chicken:
;;; csi -ss wordle_comparison.scm
;;; Invoke Gambit:
;;; gsi wordle_comparison.scm -e "(main 1)"
;;; Invoke Guile:
;;; guile -l guile_helper.scm -l wordle_comparison.scm -c "(main 1)"
;;;

;; Guile 2.2.7 needs a little help to allow symbol quoting
;; for the special characters beyond those in R5RS
;; without which Guile only allows these special characters
;; ! $ % & * + - . / : < = > ? @ ^ _ ~
;; Create a small helper file containing these two lines
    ; echo "(read-enable  'r7rs-symbols)" > guile_helper.scm
    ; echo "(print-enable 'r7rs-symbols)" >> guile_helper.scm
;; Gauche 0.9.12, Chicken 5.3.0, and Gambit 4.9.5
;; already allow the R7RS extended characters
;; " # ( ) , ; [ \ ] ` { | }

;; Test data list (target guess)
(define test-pairs
  (list
    ; Original Wordle words, all CAPS, 5 letters
    '(ALLOW LOLLY)
    '(BULLY LOLLY)
    '(ROBIN ALERT)
    '(ROBIN SONIC)
    ; Allow case sensitive words
    '(Allow Lolly)
    '(McKay MCKAY)
    '(Robin ROBIN)
    ; Allow numbers
    '(|12234| |23225|)
    '(|67225| |12225|)
    '(|83690| |14587|)
    '(|83690| |13092|)
    ; Allow longer words
    '(ROSETTA TESTATE)
    '(Chipmunk Civilize)
    ; Allow R5RS extended characters
    ; ! $ % & * + - . / : < = > ? @ ^ _ ~
    ; Words
    '(|Yell!| |Feel?|)
    '(%Interest @The_Bank)
    ; Not words
    '(|!$$%&| |$%$$*|)  ; R5RS
    '(|!$%&*+-./:<=>?@^_~| |!$%&*+-./:<=>?@^_~|)  ; R5RS
    ; Allow R7RS additional extended characters
    ; " # ' ( ) , ; [ \ ] ` { | }
    ; Thus allowing all characters from "!" to "~"
    ; per Rosetta Code Task requirement
    ; Words
    '(|We're| |She's|)  ; R7RS
    '(|Let's| |Don't|)  ; R7RS
    ; Not words
    '(|"#([{| |";#,;|); R7RS
    '(|"#'(),;[\\]`{\|}| |"#'(),;[\\]`{\|}|)))  ; R7RS

(define (symbol->char-list sym)
  (let ((char-list (string->list (symbol->string sym))))
    (map (lambda (c) (make-string 1 c)) char-list)))

(define (compare-one-letter target guess index)
  (let* ((target-unmatched-count 0)
         (guess-unmatched-count 0)
         (color "grey")
         (target-char-list (symbol->char-list target))
         (guess-char-list (symbol->char-list guess))
         (target-letter (list-ref target-char-list index))
         (guess-letter (list-ref guess-char-list index))
         (max-index (- (length target-char-list) 1)))
    (if (equal? target-letter guess-letter)
      "green"        ;; return
      (let loop ((i 0))
        (if (and (equal? (list-ref target-char-list i) guess-letter)
                 (not (equal? (list-ref guess-char-list i) guess-letter)))
          (set! target-unmatched-count (+ target-unmatched-count 1)))
        (if (<= i index)
          (if (and (equal? (list-ref guess-char-list i) guess-letter)
                   (not (equal? (list-ref target-char-list i) guess-letter)))
            (set! guess-unmatched-count (+ guess-unmatched-count 1))))
        (if (>= i index)
          (if (<= guess-unmatched-count target-unmatched-count)
            (begin
              (set! color "yellow")
              (set! i 99))))      ;; return
        (if (< i max-index)
          (loop (+ i 1))
          color)))))    ;; return

(define (wordle-compare-test words)
  (for-each (lambda (l)
              (let ((target (list-ref l 0))
                    (guess (list-ref l 1)))
                (display target)
                (display " V ")
                (display guess)
                (display " => ")
                (display (wordle-compare target guess))
                (newline)))
            words))

(define (wordle-compare target guess)
  (let* ((target-char-list (symbol->char-list target))
        (target-length (length target-char-list)))
      (let loop ((x 0)
                 (result '()))
        (if (< x target-length)
          (loop (+ x 1) (cons (compare-one-letter target guess x) result))
          (reverse result)
      ))))

;;; Main function to run when this script is called
(define (main args)
  (display "Rosetta Code Task - Wordle Comparison\n")
  (newline)
  (wordle-compare-test test-pairs)
  0)

