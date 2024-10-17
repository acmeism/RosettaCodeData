(import (scheme base)
        (scheme char)
        (scheme write)
        (only (srfi 1) drop take-while)
        (only (srfi 13) string-drop string-join string-prefix-ci? string-tokenize)
        (srfi 132))


;; Natural sort function
(define (natural-sort lst)
  ; <1><2> ignores leading, trailing and multiple adjacent spaces
  ;        by tokenizing on whitespace (all whitespace characters),
  ;        and joining with a single space
  (define (ignore-spaces str)
    (string-join (string-tokenize str) " "))
  ; <5> Remove articles from string
  (define (drop-articles str)
    (define (do-drop articles str)
      (cond ((null? articles)
             str)
            ((string-prefix-ci? (car articles) str)
             (string-drop str (string-length (car articles))))
            (else
              (do-drop (cdr articles) str))))
    (do-drop '("a " "an " "the ") str))
  ; <4> split string into number/non-number groups
  (define (group-digits str)
    (let loop ((chars (string->list str))
               (doing-num? (char-numeric? (string-ref str 0)))
               (groups '()))
      (if (null? chars)
        (map (lambda (s) ; convert numbers to actual numbers
               (if (char-numeric? (string-ref s 0))
                 (string->number s)
                 s))
             (map list->string groups)) ; leave groups in reverse, as right-most significant
        (let ((next-group (take-while (if doing-num?
                                        char-numeric?
                                        (lambda (c) (not (char-numeric? c))))
                                      chars)))
          (loop (drop chars (length next-group))
                (not doing-num?)
                (cons next-group groups))))))
  ;
  (list-sort
    (lambda (a b) ; implements the numeric fields comparison <4>
      (let loop ((lft (group-digits (drop-articles (ignore-spaces a))))
                 (rgt (group-digits (drop-articles (ignore-spaces b)))))
        (cond ((null? lft) ; a is shorter
               #t)
              ((null? rgt) ; b is shorter
               #f)
              ((equal? (car lft) (car rgt)) ; if equal, look at next pair
               (loop (cdr lft) (cdr rgt)))
              ((and (number? (car lft)) ; compare as numbers
                    (number? (car rgt)))
               (< (car lft) (car rgt)))
              ((and (string? (car lft)) ; compare as strings
                    (string? (car rgt)))
               (string-ci<? (car lft) (car rgt))) ; <3> ignoring case
              ((and (number? (car lft)) ; strings before numbers
                    (string? (car rgt)))
               #f)
              ((and (string? (car lft)) ; strings before numbers
                    (number? (car rgt)))
               #t))))
    lst))

;; run string examples
(define (display-list title lst)
  (display title) (newline)
  (display "[\n") (for-each (lambda (i) (display i)(newline)) lst) (display "]\n"))

(for-each
  (lambda (title example)
    (display title) (newline)
    (display-list "Text strings:" example)
    (display-list "Normally sorted:" (list-sort string<? example))
    (display-list "Naturally sorted:" (natural-sort example))
    (newline))
  '("# Ignoring leading spaces" "# Ignoring multiple adjacent spaces (m.a.s.)"
    "# Equivalent whitespace characters" "# Case Independent sort"
    "# Numeric fields as numerics" "# Numeric fields as numerics - shows sorting from right"
    "# Title sorts")
  '(("ignore leading spaces: 2-2" " ignore leading spaces: 2-1" "  ignore leading spaces: 2+0" "   ignore leading spaces: 2+1")
    ("ignore m.a.s spaces: 2-2" "ignore m.a.s  spaces: 2-1" "ignore m.a.s   spaces: 2+0" "ignore m.a.s    spaces: 2+1")
    ("Equiv. spaces: 3-3" "Equiv.\rspaces: 3-2" "Equiv.\x0c;spaces: 3-1" "Equiv.\x0b;spaces: 3+0" "Equiv.\nspaces: 3+1" "Equiv.\tspaces: 3+2")
    ("cASE INDEPENDENT: 3-2" "caSE INDEPENDENT: 3-1" "casE INDEPENDENT: 3+0" "case INDEPENDENT: 3+1")
    ("foo100bar99baz0.txt" "foo100bar10baz0.txt" "foo1000bar99baz10.txt" "foo1000bar99baz9.txt")
    ("foo1bar99baz4.txt" "foo2bar99baz3.txt" "foo4bar99baz1.txt" "foo3bar99baz2.txt")
    ("The Wind in the Willows" "The 40th step more" "The 39 steps" "Wanda")))
