;; using regexp /[chars]/g

(define (strip-chars string chars)
  (string-replace string (string-append "/[" chars "]/g") ""))

(strip-chars "She was a soul stripper. She took my heart!" "aei")
    → "Sh ws soul strppr. Sh took my hrt!"
