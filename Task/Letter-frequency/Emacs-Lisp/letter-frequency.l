(defun tally-letter-frequency-in-file ()
  "Open a file and count the number of times each letter appears."
  (let ((alphabet "abcdefghijklmnopqrstuvwxyz")    ; variable to hold letters we will be counting
	(current-letter)                               ; variable to hold current letter we will be counting
	(count)                                        ; variable to count how many times current letter appears
	(case-fold-search t))                          ; ignores case
    (find-file "~/Documents/Elisp/MobyDick.txt")   ; open file in a buffer (or switch to buffer if file is already open)
  (while (>= (length alphabet) 1)                  ; as long as there is at least 1 letter left in alphabet
    (beginning-of-buffer)                          ; go to the beginning of the buffer
    (setq current-letter (substring alphabet 0 1)) ; set current-letter to first letter of alphabet
    (setq count (how-many current-letter))         ; count how many of this letter in file
    (end-of-buffer)                                ; go to the end of the buffer
    (insert (format "\n%s%s - %7d" current-letter (upcase current-letter) count))  ; write how many times that letter appears
    (setq alphabet (substring alphabet 1 nil)))    ; remove first letter from alphabet
(insert "\n")))
