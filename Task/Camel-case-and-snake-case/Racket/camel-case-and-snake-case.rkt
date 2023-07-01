#lang racket

(define input '("snakeCase" "snake_case" "variable_10_case" "variable10Case" "ɛrgo rE tHis" "hurry-up-joe!" "c://my-docs/happy_Flag-Day/12.doc" "  spaces  "))

;; make '-' the canonical separator by replacing '_' and ' ' with '-'
(define (dashify s)
  (regexp-replace* #px"[_ ]" s "-"))

;; replace -X with -x for any upper-case X
(define (dash-upper->dash-lower s)
  (regexp-replace* #px"-[[:upper:]]" s string-downcase))

;; replace X with -x for any upper-case X
(define (upper->dash-lower s)
  (regexp-replace* #px"[[:upper:]]"
                   s
                   (λ (s) (string-append "-" (string-downcase s)))))

(define (string-kebabcase s)
  (upper->dash-lower (dash-upper->dash-lower (dashify s))))

(define (string-snakecase s)
  ;; once we have kebabcase, snakecase is easy, just change '-' to '_'
  (regexp-replace* #px"-" (string-kebabcase s) "_"))

(define (string-camelcase s)
  ;; camel is pretty easy, too - replace dash-anything with uppercase-anything
  ;; note: this will change non-letters as well, so -10 becomes just 10
  (regexp-replace* #px"-." (string-kebabcase s) (λ (s) (string-upcase (substring s 1 2)))))

(define (convert-case to-case case-name namelist)
  (printf "Conversions to ~a:~n" case-name)
  (for ([name namelist])
    (printf "'~a' --> '~a'~n" name (to-case (string-trim name))))
  (printf "~n"))

(convert-case string-kebabcase "kebab-case" input)
(convert-case string-snakecase "snake_case" input)
(convert-case string-camelcase "camelCase" input)
