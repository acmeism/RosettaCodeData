(require 'calc-bin)

(defun is-palindrome-p (str)
  "Test if STR is a palindrome."
  (equal str (reverse str)))

(defun ends-in-zero-p (str)
  "Test if STR ends in zero (0)."
  (string-match-p "0\\'" str))

(defun base-3-to-base-2 (str)
  "Convert STR from base 3 to base 2.
STR must be a string containing only digits 0-2."
  (let ((calc-number-radix 2)
        (base-10-number (string-to-number str 3)))
    ;; return string of base 2 number
    (format "%s" (math-format-radix base-10-number))))

(defun base-3-to-base-10 (str)
  "Convert STR from base 3 to base 10.
STR must be a string containing only digits 0-2."
  (let ((calc-number-radix 10)
        (base-10-number (string-to-number str 3)))
    ;; return string of base 10 number
    (format "%s" (number-to-string base-10-number))))

(defun find-palindromes (number)
  "Find NUMBER of pairs of palindrome numbers.
The pair consists of one number which is a palindrome in
base 3 and a base 2 number of the same value that is
also a palindrome in base 2."
  (let ((calc-number-radix 3)
        (base-3-partial-string)
        (base-3-partial-number 0)
        (base-3-string)
        (base-2-string)
        (base-10-string)
        (count 2))
    (insert (format "\n%12s  %23s  %37s" "Base_10" "Base_3" "Base_2"))
    (insert "\n----------------------------------------------------------------------------")
    (insert (format "\n%12s  %23s  %37s" "0"  "0"  "0"))
    (insert (format "\n%12s  %23s  %37s" "1"  "1"  "1"))
    (while (< count number)
      (setq base-3-partial-number (1+ base-3-partial-number))
      (setq base-3-partial-string (format "%s" (math-format-radix base-3-partial-number)))
      (setq base-3-string (concat base-3-partial-string "1" (reverse base-3-partial-string)))
      (unless (ends-in-zero-p base-3-string)
        (setq base-2-string (base-3-to-base-2 base-3-string))
        (when (is-palindrome-p base-2-string)
          (setq count (1+ count))
          (setq base-10-string (base-3-to-base-10 base-3-string))
          (insert (format "\n%12s  %23s  %37s" base-10-string base-3-string base-2-string)))))))
