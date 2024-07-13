;; version 1, which takes advantage of the how-many function,
;; which runs only in a buffer

(defun count-substrings (text substring)
 "Count non-overlapping occurrences of SUBSTRING in TEXT."
    (with-temp-buffer          ; create a temporary buffer, which will be deleted when function finishes
      (insert text)            ; insert TEXT into the empty buffer
      (goto-char (point-min))  ; go to the beginning of the buffer
      (how-many substring)))   ; count how many occurrences of SUBSTRING


;; version 2, which operates on a string

(defun count-substrings (text substring)
  "Count non-overlapping occurences of SUBSTRING in TEXT."
  (let ((substrings))                               ; empty list to add occurrences of SUBSTRING as we find them
    (while (string-match substring text)            ; as long as we can find SUBSTRING in TEXT
      (push (match-string 0 text) substrings)       ; add the SUBSTRING we found to the list of substrings
      (setq text (replace-match "" nil nil text)))  ; remove SUBSTRING from text, and repeat while loop
    (length substrings)))                           ; count number of items in substrings list
