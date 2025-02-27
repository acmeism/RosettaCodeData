(defun rob-even-p (integer)
  "Test if INTEGER is even."
  (= (% integer 2) 0))

(defun rob-odd-p (integer)
  "Test if INTEGER is odd."
  (not (rob-even-p integer)))

(defun both-odd-or-both-even-p (x y)
  "Test if X and Y are both even or both odd."
  (or (and (rob-even-p x) (rob-even-p y))
      (and (rob-odd-p x) (rob-odd-p y))))

(defun word-lengths (words)
  "Convert WORDS into list of lengths of each word."
  (mapcar 'length words))

(defun get-one-row (row-number rows-columns-words)
  "Get ROW-NUMBER row from ROWS-COLUMNS-WORDS.
ROWS-COLUMNS-WORDS is list of lists in form of row, column, word."
  (seq-filter
   (lambda (element)
     (= row-number (car element)))
   rows-columns-words))

(defun get-one-word (row-number column-number rows-columns-words)
  "Get one word from ROWS-COLUMNS-WORDS at ROW-NUMBER and COLUMN-NUMBER.
ROWS-COLUMNS-WORDS is list of lists in form of row, column, word."
  (delq nil
        (mapcar
         (lambda (element)
           (when (= column-number (nth 1 element))
             (nth 2 element)))
         (get-one-row row-number rows-columns-words))))

(defun get-last-row (rows-columns-words)
  "Get the number of the last row of ROWS-COLUMNS-WORDS.
ROWS-COLUMNS-WORDS is a list of lists, each list in the form of
row, column, word."
  (apply 'max (mapcar 'car rows-columns-words)))

(defun list-nth-column (column rows-columns-words)
  "List the words in column COLUMN of ROWS-COLUMNS-WORDS.
ROWS-COLUMNS-WORDS is a list of lists, each list in the form of row, column,
word."
  (let   ((row 1)
          (column-word)
          (last-row (get-last-row rows-columns-words ))
          (matches nil))
    (while (and (<= row last-row)
                (<= column (get-last-column rows-columns-words)))
      (setq column-word (get-one-word row column rows-columns-words))
      (when (null column-word)
        (setq column-word ""))
      (push column-word matches)
      (setq row (1+ row)))
    (flatten-tree (nreverse matches))))

(defun get-widest-in-column (column)
  "Get the widest word in COLUMN, which is a list of words."
  (apply #'max (word-lengths column)))

(defun get-column-width (column)
  "Calculate the width of COLUMN, which is a list of words."
  (+ (get-widest-in-column column) 2))

(defun get-column-widths (rows-columns-words)
  "Make a list of the column widths in ROWS-COLUMNS-WORDS.
ROWS-COLUMNS-WORDS is list of lists, with each list in the form of row, column,
word."
  (let ((last-column (get-last-column rows-columns-words))
        (column 1)
        (columns))
    (while (<= column last-column)
      (push (get-column-width (list-nth-column column rows-columns-words)) columns)
      (setq column (1+ column)))
    (reverse columns)))

(defun add-column-widths (widths rows-columns-words)
  "Add WIDTHS to ROWS-COLUMNS-WORDS.
ROWS-COLUMNS-WORDS is a list of lists, with each list in the form of row,
column, word. WIDTHS are the widths of each column. Output is a
list of lists, with each list in the form of column-width, row,
column, word."
  (let ((new-data)
        (new-database)
        (column)
        (width))
    (dolist (data rows-columns-words)
      (setq column (cadr data))
      (setq width (nth (- column 1) widths))
      (setq new-data (push width data))
      (push new-data new-database))
    (nreverse new-database)))

(defun get-last-column (rows-columns-words)
  "Get the number of the last column in ROWS-COLUMNS-WORDS."
  (apply 'max (mapcar 'cadr rows-columns-words)))

(defun create-rows-columns-words ()
  "Put text from column-data.txt file in lists.
Each list consists of a row number, a column number, and a word."
  (let ((lines)
        (line-number 0)
        (word-number)
        (words))
    (with-temp-buffer
      (insert-file-contents "~/Documents/Elisp/column_data.txt")
      (beginning-of-buffer)
      (dolist (line (split-string (buffer-string) "[\r\n]" :no-nulls))
        (push line lines))
      (setq lines (nreverse lines)))
    (dolist (line lines)
      (setq line-number (1+ line-number))
      (setq word-number 0)
      (dolist (word (split-string line "\\$" :no-nulls))
        (setq word-number (1+ word-number))
        (push (list line-number word-number word) words)))
    (setq words (nreverse words))))

(defun pad-for-center-align (column-width text)
  "Pad TEXT to center in space of COLUMN-WIDTH."
  (let* ((text-width (length text))
         (total-padding-length (- column-width text-width))
         (pre-padding-length)
         (post-padding-length)
         (pre-padding)
         (post-padding))
    (if (both-odd-or-both-even-p text-width column-width)
        (progn
          (setq pre-padding-length (/ total-padding-length 2))
          (setq post-padding-length pre-padding-length))
      (setq pre-padding-length (+ (/ total-padding-length 2) 1))
      (setq post-padding-length (- pre-padding-length 1)))
    (setq pre-padding (make-string pre-padding-length ? ))
    (setq post-padding (make-string post-padding-length ? ))
    (format "%s%s%s" pre-padding text post-padding)))

(defun create-a-center-aligned-line (widths-1row-columns-words)
  "Create a centered line based on WIDTHS-1ROW-COLUMNS-WORDS.
WIDTHS-1ROW-COLUMNS-WORDS is a list of lists. Each list consists
of the column-width, the row number, the column number, and the
word. The row number is the same in all lists."
  (let ((full-line "")
        (next-section))
    (insert "\n")
    (dolist (word-data widths-1row-columns-words)
      ;; below, nth 0 is the column width, nth 3 is the word
      (setq next-section (pad-for-center-align (nth 0 word-data) (nth 3 word-data)))
      (setq full-line (concat full-line next-section)))
    (insert full-line)))

(defun pad-for-left-align (column-width text)
  "Pad TEXT to left-align in space of COLUMN-WIDTH."
  (let* ((text-width (length text))
         (post-padding-length (- column-width text-width)))
    (setq post-padding (make-string post-padding-length ? ))
    (format "%s%s" text post-padding)))

(defun create-a-left-aligned-line (widths-1row-columns-words)
  "Create a left-aligned line based on WIDTHS-1ROW-COLUMNS-WORDS.
Each element of WIDTHS-1ROW-COLUMNS-WORDS consists of the column
width, the row number, the column number, and the word. The row
number is the same in every case."
  (let ((full-line "")
        (next-section))
    (insert "\n")
    (dolist (one-item widths-1row-columns-words)
      (setq next-section (pad-for-left-align (nth 0 one-item) (nth 3 one-item)))
      (setq full-line (concat full-line next-section)))
    (insert full-line)))

(defun pad-for-right-align (column-width text)
  "Pad TEXT to right-align in space of COLUMN-WIDTH."
  (let* ((text-width (length text))
         (pre-padding-length (- column-width text-width)))
    (setq pre-padding (make-string pre-padding-length ? ))
    (format "%s%s" pre-padding text)))

(defun create-a-right-aligned-line (widths-1row-columns-words)
  "Create a right-aligned line based on WIDTHS-1ROW-COLUMNS-WORDS.
Each element of WIDTHS-1ROW-COLUMNS-WORDS consists of the column
width, the row number, the column number, and the word. The row
number is the same in every case."
  (let ((full-line "")
        (next-section))
    (insert "\n")
    (dolist (one-item widths-1row-columns-words)
      (setq next-section (pad-for-right-align (nth 0 one-item) (nth 3 one-item)))
      (setq full-line (concat full-line next-section)))
    (insert full-line)))

(defun left-align-lines (rows-columns-words)
  "Write ROWS-COLUMNS-WORDS in left-aligned columns.
ROWS-COLUMNS-WORDS is a list of lists. Each list consists of the
row number, the column number, and the word."
  (let* ((row-number 1)
         (column-widths (get-column-widths rows-columns-words))
         (last-row (get-last-row rows-columns-words))
         (one-row)
         (width-place 0))
    (while (<= row-number last-row)
      (setq one-row (get-one-row row-number rows-columns-words))
      (setq one-row (add-column-widths column-widths one-row))
      (create-a-left-aligned-line one-row)
      (setq row-number (1+ row-number))
      (setq width-place (1+ width-place)))))

(defun right-align-lines (rows-columns-words)
  "Write ROWS-COLUMNS-WORDS in right-aligned columns.
ROWS-COLUMNS-WORDS is a list of lists. Each list consists of the
row number, the column number, and the word."
  (let* ((row-number 1)
         (column-widths (get-column-widths rows-columns-words))
         (last-row (get-last-row rows-columns-words))
         (one-row)
         (width-place 0))
    (while (<= row-number last-row)
      (setq one-row (get-one-row row-number rows-columns-words))
      (setq one-row (add-column-widths column-widths one-row))
      (create-a-right-aligned-line one-row)
      (setq row-number (1+ row-number))
      (setq width-place (1+ width-place)))))

(defun center-align-lines (rows-columns-words)
  "Write ROWS-COLUMNS-WORDS in center-aligned columns.
ROWS-COLUMNS-WORDS is a list of lists. Each list consists of the
row number, the column number, and the word."
  (let* ((row-number 1)
         (column-widths (get-column-widths rows-columns-words))
         (last-row (get-last-row rows-columns-words))
         (one-row)
         (width-place 0))
    (while (<= row-number last-row)
      (setq one-row (get-one-row row-number rows-columns-words))
      (setq one-row (add-column-widths column-widths one-row))
      (create-a-center-aligned-line one-row)
      (setq row-number (1+ row-number))
      (setq width-place (1+ width-place)))))

(defun align-lines (alignment rows-columns-words)
  "Write ROWS-COLUMNS-WIDTHS with given ALIGNMENT.
ROWS-COLUMNS-WIDTHS consists of a list of lists. Each internal list contains width of column, row number, column number, and a word."
  (let ((align-function (pcase alignment
                          ('left 'left-align-lines)
                          ("left" 'left-align-lines)
                          ('center 'center-align-lines)
                          ("center" 'center-align-lines)
                          ('right 'right-align-lines)
                          ("right" 'right-align-lines))))
    (funcall align-function rows-columns-words)))
