(defun tally-letter-frequency-in-file ()
  (let ((alphabet "abcdefghijklmnopqrstuvwxyz")
	(current-letter)
	(count)
	(case-fold-search t)) ; ignores case
    (find-file "~/Documents/Elisp/MobyDick.txt") ; identify file to work with
  (while (>= (length alphabet) 1) ; as long as there is at least 1 letter left in alphabet
    (beginning-of-buffer)
    (setq current-letter (substring alphabet 0 1)) ; set current-letter to first letter of alphabet
    (setq count (how-many current-letter)) ; count how many of this letter in file
    (end-of-buffer)
    (insert (format "\n%s%s - %7d" current-letter (upcase current-letter) count))
    (setq alphabet (substring alphabet 1 nil))) ; remove first letter from alphabet
(insert "\n")))
