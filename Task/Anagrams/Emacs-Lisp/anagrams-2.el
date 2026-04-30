(defun code-letters (str)
  "Sort STR into alphabetized list of individual letters."
  (sort (split-string str "" t) #'string<))

(defun code-letters-to-string (str)
  "Sort STR alphabetically and combine into one string."
  (apply #'concat (code-letters str)))

(defun add-to-hash (key value table)
  "If KEY exists, add VALUE to list of values.
If KEY does not exist, associate value with KEY."
  (let ((current-values))
    (if (gethash key table)
        (progn
          (setq current-values (gethash key table))
          (setq current-values (push value current-values))
          (puthash key current-values table))
      (puthash key (list value) table))))

(defun create-list-of-numbers (hash-table)
  "Create a list of numbers from HASH-TABLE."
  (let ((current-number)
        (list-of-numbers))
    (setq list-of-numbers (list))  ; omit?
    (maphash (lambda (key value)
               (setq current-number (car (gethash key hash-table)))
               (push current-number list-of-numbers))
             hash-table)
  list-of-numbers))

(defun find-largest-number-in-hash (hash-table)
  "Find largest number in HASH-TABLE."
  (let ((list-of-numbers))
    (setq list-of-numbers (create-list-of-numbers hash-table))
    (apply #'max list-of-numbers)))

(defun find-longest-lists-of-anagrams (&optional file)
  "Find the set(s) of largest number of anagrams in file wordlist.txt"
  (let ((largest-number)
        (hash-key)
        (dictionary-table (make-hash-table :test 'equal)))
    ;; Path and filename below needs to be adapted to individual case if
    ;; FILE is *not* passed to this function
    (with-temp-buffer
      (insert-file-contents (or file "~/Documents/Elisp/wordlist.txt"))
      (beginning-of-buffer)
      ;; set up hash table with key and word(s)
      ;; key = letters of word, but with letters in
      ;; alphabetical order. Create list word(s) associated
      ;; with key.
      (dolist (current-word (split-string (buffer-string) "\n"))
        (setq hash-key (code-letters-to-string current-word))
        (add-to-hash hash-key current-word dictionary-table))
      ;; Count number of anagram words
      (maphash (lambda (key value)
                 "Add number of anagram words to VALUE."
                 (add-to-hash key (length (gethash key dictionary-table)) dictionary-table))
               dictionary-table)
      ;; find the size of the largest list(s) of anagrams
      (setq largest-number (find-largest-number-in-hash dictionary-table)))
    ;; set up empty buffer to show results
    (with-current-buffer (pop-to-buffer "anagram-listing")
      (erase-buffer)
      ;; show results
      (maphash (lambda (key value)
                 "Display longest lists of anagrams."
                 (when (= largest-number (car (gethash key dictionary-table)))
                     (mapc
                      (lambda (element)
                        "Insert ELEMENT followed by one space in buffer."
                        (insert (format "%s " element)))
                      (cdr (gethash key dictionary-table)))
                     (insert "\n")))
                   dictionary-table))))
