; file:   stringcount.lsp
; url:    http://rosettacode.org/wiki/Count_occurrences_of_a_substring
; author: oofoe 2012-01-29

; Obvious (and non-destructive...)

; Note that NewLISP performs an /implicit/ slice on a string or list
; with this form "(start# end# stringorlist)". If the end# is omitted,
; the slice will go to the end of the string. This is handy here to
; keep removing the front part of the string as it gets matched.

(define (scount needle haystack)
  (let ((h (copy haystack)) ; Copy of haystack string.
        (i 0)               ; Cursor.
        (c 0))              ; Count of occurences.

    (while (setq i (find needle h))
      (inc c)
      (setq h ((+ i (length needle)) h)))

    c))                     ; Return count.

; Tricky -- Uses functionality from replace function to find all
; non-overlapping occurrences, replace them, and return the count of
; items replaced in system variable $0.

(define (rcount needle haystack)
  (replace needle haystack "X") $0)

; Test

(define (test f needle haystack)
  (println "Found " (f needle haystack)
           " occurences of '" needle "' in '" haystack "'."))

(dolist (f (list scount rcount))
        (test f "glart" "hinkerpop")
        (test f "abab"  "ababababab")
        (test f "th"    "the three truths")
        (println)
        )

(exit)
