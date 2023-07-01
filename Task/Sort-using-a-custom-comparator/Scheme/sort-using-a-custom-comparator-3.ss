(define strings '(
  "This" "Is" "A" "Set" "Of" "Strings" "To" "Sort" "duplicated"
  "this" "is" "a" "set" "of" "strings" "to" "sort" "duplicated"))

(print
  (sort strings
    (lambda two
      (define sizes (map string-length two))
      (if (apply = sizes)
        (apply string-ci<? two)
        (apply > sizes)))))
