(defun code-letters (str)
  "Sort STR into alphabetized list of individual letters."
  (sort (split-string str "" t) #'string<))

(defun code-letters-to-string (str)
  "Sort STR alphabetically and combine into one string."
  (apply #'concat (code-letters str)))

(defun remove-periods (str)
  "Remove periods (full stops) from STR."
  (string-replace "." "" str))

(defun list-pair (str)
  "Create paired list from STR, STR (unchanged) and alphabetized order of STR."
  ;; Remove periods from alphabetized order to make regex matching easier
  (let ((letter-list (remove-periods (code-letters-to-string str))))
    (list letter-list str)))

(defun pair-up (words)
  "Make list of lists of paired words, one alphabetized one original."
  (let ((paired-list)
        (temp-pair))
    (dolist (word words)
      (setq temp-pair (list-pair word))
      (push temp-pair paired-list))
    paired-list))

(defun create-list-of-numbers (my-list)
  "Create list of numbers from MY-LIST."
  (let ((list-of-numbers))
    (dolist (one-pair my-list)
      (push (car one-pair) list-of-numbers))
    list-of-numbers))

(defun get-largest-number (my-list)
  "Find largest number in MY-LIST."
  (let ((list-of-numbers))
    (setq list-of-numbers (create-list-of-numbers my-list))
    (apply #'max list-of-numbers)))

(defun make-list-matching-words (coded-word-and-original number-and-code-pair)
  "List original words whose code matches code in NUMBER-AND-CODE-PAIR."
  (dolist (word-pair coded-word-and-original)
    ;; test if coded word in CODED-WORD-AND-ORIGINAL matches
    ;; coded word in NUMBER-AND-CODE-PAIR
    (when (string= (nth 0 word-pair) (nth 1 number-and-code-pair))
      ;; insert the original word
            (insert (format "%s " (nth 1 word-pair)))))
        (insert "\n"))

(defun count-anagrams ()
  "Count the number of anagrams in file wordlist.txt"
  (let ((coded-word-and-original)
        (just-coded-words)
        (unique-coded-words)
        (count-and-code)
        (number-of-anagrams)
        (largest-number))
    ;; Path below needs to be adapted to individual case
    (find-file "~/Documents/Elisp/wordlist.txt")
    (beginning-of-buffer)
    ;; create list of lists of coded words and originals
    (setq coded-word-and-original (pair-up (split-string (buffer-string) "\n")))
    (find-file "temp-all-coded")
    (erase-buffer)
    (dolist (number-and-code-pair coded-word-and-original)
      ;; make list of just the coded words
      (push (nth 0 number-and-code-pair) just-coded-words))
    (dolist (one-word just-coded-words)
      ;; write list of coded words to buffer for later processing
      (insert (format "%s\n" one-word)))
    ;; create a list of coded words with no repetitions
    (setq unique-coded-words (seq-uniq just-coded-words))
    (dolist (one-code unique-coded-words)
      (find-file "temp-all-coded")
      (beginning-of-buffer)
      ;; count the number of times ONE-CODE appears in buffer
      (setq number-of-anagrams (how-many (format "^%s$" one-code)))
      (if (>= number-of-anagrams 1)  ; eliminate "words" of zero length
          (push (list number-of-anagrams one-code) count-and-code)))
    (find-file "anagram-listing")
    (erase-buffer)
    (setq largest-number (get-largest-number count-and-code))
    (dolist (number-and-code-pair count-and-code)
      ;; when the number in NUMBER-AND-CODE-PAIR = largest number of anagrams
      (when (= (nth 0 number-and-code-pair) largest-number)
        (make-list-matching-words coded-word-and-original number-and-code-pair)))))
