(defun order-alphabetically (str)
  "Put letters in STR in alphabetical order."
    ;; split STR into list of individual letters in alphabetical order
    ;; and then join the letters back into one string
    (apply #'concat (sort (split-string str "" t) #'string<)))

(defun ordered-alphabetically-p (str)
  "Test if letters STR are in alphabetical order."
    (string= (order-alphabetically str) str))


(defun make-list-of-ordered-words (word-list)
  "Create subset of ordered words from words in WORD-LIST."
  (let ((ordered-words))
    (dolist (one-word word-list)
      (when (ordered-alphabetically-p one-word)
        (push (format "%s" one-word) ordered-words)))
    ordered-words))

(defun list-length-words (word-list)
  "From the words in WORD-LIST, create list of pairs of words and their length."
  (let ((paired-list)
        (temp-pair))
    (dolist (one-word word-list)
      (setq temp-pair (list (length one-word) one-word))
      (push temp-pair paired-list))
    paired-list))

(defun create-list-of-numbers (numbers-and-words-list)
  "Create list of numbers from NUMBERS-AND-WORDS-LIST."
  (let ((list-of-numbers))
    (dolist (one-pair numbers-and-words-list)
      (push (car one-pair) list-of-numbers))
    list-of-numbers))

(defun get-largest-number (numbers-and-words-list)
  "Find largest number in NUMBERS-AND-WORDS-LIST."
  (let ((list-of-numbers))
    (setq list-of-numbers (create-list-of-numbers numbers-and-words-list))
    (apply #'max list-of-numbers)))

(defun make-list-matching-words (largest-number numbers-and-words-list)
  "List words whose length equals LARGEST-NUMBER."
  (dolist (number-and-word-pair numbers-and-words-list)
    ;; test if number in NUMBER-AND-WORD-PAIR matches
    ;; LARGEST-NUMBER
    (when (= (nth 0 number-and-word-pair) largest-number)
      ;; insert the original word
            (insert (format "%s " (nth 1 number-and-word-pair)))))
        (insert "\n"))

(defun get-longest-ordered-words ()
  "Find the longest ordered words in file wordlist.txt.
A word is an ordered word if its letters are in alphabetical order."
  (let ((all-word-list)
        (just-ordered-words)
        (lengths-and-words)
        (longest-word-length))
    ;; Path below needs to be adapted to individual case
    (find-file "~/Documents/Elisp/wordlist.txt")
    (beginning-of-buffer)
    ;; Create list of all words in file
    (setq all-word-list (split-string (buffer-string) "\n"))
    ;; Test if a word is an ordered word, if so add to JUST-ORDERED-WORDS
    (dolist (one-word all-word-list)
      (if (ordered-alphabetically-p one-word)
          (push one-word just-ordered-words)))
    ;; pair word lengths with ordered words
    (setq lengths-and-words (list-length-words just-ordered-words))
    ;; Get the longest word length
    (setq longest-word (get-largest-number lengths-and-words))
    (find-file "longest-ordered-words")
    (erase-buffer)
    ;; list the longest ordered words
    (make-list-matching-words longest-word lengths-and-words)))
