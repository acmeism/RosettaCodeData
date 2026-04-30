(defun prepare-data ()
  "Process data into list of lists."
  (let ((all-lines)
        (processed-line))
    (dolist (one-line (split-string "Given$a$text$file$of$many$lines,$where$fields$within$a$line$
are$delineated$by$a$single$'dollar'$character,$write$a$program
that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$
column$are$separated$by$at$least$one$space.
Further,$allow$for$each$word$in$a$column$to$be$either$left$
justified,$right$justified,$or$center$justified$within$its$column." "[\n\r]" :OMIT-NULLS))
      (dolist (one-word (split-string one-line "\\$"))
        (push one-word processed-line))
      (push (nreverse processed-line) all-lines)
      (setq processed-line nil))
    (nreverse all-lines)))

(defun get-column (column-number data)
  "Get words from COLUMN-NUMBER column in DATA."
  (let ((column-result))
    (setq column-number (- column-number 1))
    (dolist (line data)
      (if (nth column-number line)
          (push (nth column-number line) column-result)
        (push "" column-result)))
    column-result))

(defun calc-column-width (column-number data)
  "Calculate padded width for COLUMN-NUMBER in DATA."
  (let ((column-words (get-column column-number data)))
    (+ 2 (apply #'max (mapcar #'length column-words)))))

(defun get-last-column (data)
  "Find the last column in DATA."
  (apply #'max (mapcar #'length data)))

(defun get-column-widths (data)
  "Get a list of column widths from DATA."
  (let ((current-column 1)
        (last-column (get-last-column data))
        (column-widths))
    (while (<= current-column last-column)
      (push (calc-column-width current-column data) column-widths)
      (setq current-column (1+ current-column)))
    (nreverse column-widths)))

(defun get-one-column-width (column-number data)
  "Get column width of COLUMN-NUMBER from DATA."
  (let ((column-widths (get-column-widths data)))
    (nth (- column-number 1) column-widths)))

(defun center-align-one-word (word column-width)
  "Center align WORD in space of COLUMN-WIDTH."
  (let* ((word-width (length word))
         (total-padding (- column-width word-width))
        (pre-padding-length (/ total-padding 2))
        (post-padding-length (- column-width (+ pre-padding-length word-width)))
        (pre-padding (make-string pre-padding-length ? ))
        (post-padding (make-string post-padding-length ? )))
     (insert (format "%s%s%s" pre-padding word post-padding))))

(defun center-align-one-line (one-line column-widths)
  "Center align ONE-LINE using COLUMN-WIDTHS."
  (let ((word-position 0))
    (dolist (word one-line)
      (center-align-one-word word (nth word-position column-widths))
      (setq word-position (1+ word-position)))))

(defun center-align-lines (data)
  "Center align columns of words in DATA."
  (let ((column-widths (get-column-widths data)))
    (dolist (one-line data)
      (center-align-one-line one-line column-widths)
      (insert (format "%s" "\n")))))

(defun left-align-one-word (word column-width)
  "Left align WORD in space of COLUMN-WIDTH."
  (let* ((word-width (length word))
         (total-padding (- column-width word-width))
        (pre-padding-length 1)
        (post-padding-length (- column-width (+ pre-padding-length word-width)))
        (pre-padding (make-string pre-padding-length ? ))
        (post-padding (make-string post-padding-length ? )))
     (insert (format "%s%s%s" pre-padding word post-padding))))

(defun left-align-one-line (one-line column-widths)
  "Left align ONE-LINE using COLUMN-WIDTHS."
  (let ((word-position 0))
    (dolist (word one-line)
      (left-align-one-word word (nth word-position column-widths))
      (setq word-position (1+ word-position)))))

(defun left-align-lines (data)
  "Left align columns of words in DATA."
  (let ((column-widths (get-column-widths data)))
    (dolist (one-line data)
      (left-align-one-line one-line column-widths)
      (insert (format "%s" "\n")))))

(defun right-align-one-word (word column-width)
  "Right align WORD in space of COLUMN-WIDTH."
  (let* ((word-width (length word))
         (total-padding (- column-width word-width))
        (post-padding-length 1)
        (pre-padding-length (- column-width (+ post-padding-length word-width)))
        (pre-padding (make-string pre-padding-length ? ))
        (post-padding (make-string post-padding-length ? )))
     (insert (format "%s%s%s" pre-padding word post-padding))))

(defun right-align-one-line (one-line column-widths)
  "Right align ONE-LINE using COLUMN-WIDTHS."
  (let ((word-position 0))
    (dolist (word one-line)
      (right-align-one-word word (nth word-position column-widths))
      (setq word-position (1+ word-position)))))

(defun right-align-lines (data)
  "Right align columns of words in DATA."
  (let ((column-widths (get-column-widths data)))
    (dolist (one-line data)
      (right-align-one-line one-line column-widths)
      (insert (format "%s" "\n")))))

(defun align-lines (alignment data)
  "Write DATA with given ALIGNMENT.
DATA consists of a list of lists. Each internal list conists of a list
of words."
  (let ((align-function (pcase alignment
                          ('left 'left-align-lines)
                          ("left" 'left-align-lines)
                          ('center 'center-align-lines)
                          ("center" 'center-align-lines)
                          ('right 'right-align-lines)
                          ("right" 'right-align-lines))))
    (funcall align-function data)))
