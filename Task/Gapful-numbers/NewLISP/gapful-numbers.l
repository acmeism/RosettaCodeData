; Part 1: Useful functions

;; Create an integer out of the first and last digits of a given integer
(define (first-and-last-digits number)
 (local (digits first-digit last-digit)
  (set 'digits (format "%d" number))
  (set 'first-digit (first digits))
  (set 'last-digit (last digits))
  (int (append first-digit last-digit))))

;; Divisbility test
(define (divisible-by? num1 num2)
 (zero? (% num1 num2)))

;; Gapfulness test
(define (gapful? number)
 (divisible-by? number (first-and-last-digits number)))

;; Increment until a gapful number is found
(define (next-gapful-after number)
 (do-until (gapful? number)
  (++ number)))

;; Return a list of gapful numbers beyond some (excluded) lower limit.
(define (gapful-numbers quantity lower-limit)
 (let ((gapfuls '()) (number lower-limit))
  (dotimes (counter quantity)
   (set 'number (next-gapful-after number))
   (push number gapfuls))
  (reverse gapfuls)))

;; Format a list of numbers together into decimal notation.
(define (format-many numbers)
 (map (curry format "%d") numbers))

;; Format a list of integers on one line with commas
(define (format-one-line numbers)
 (join (format-many numbers) ", "))

;; Display a quantity of gapful numbers beyond some (excluded) lower limit.
(define (show-gapfuls quantity lower-limit)
 (println "The first " quantity " gapful numbers beyond " lower-limit " are:")
 (println (format-one-line (gapful-numbers quantity lower-limit))))

; Part 2: Complete the task
(show-gapfuls 30 99)
(show-gapfuls 15 999999)
(show-gapfuls 10 999999999)
(exit)
