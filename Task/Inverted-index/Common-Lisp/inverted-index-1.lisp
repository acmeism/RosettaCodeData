(defpackage rosettacode.inverted-index
  (:use cl))
(in-package rosettacode.inverted-index)

;; Return a list of tokens in the string LINE.  This is rather
;; complicated as CL has no good standard function to do it.
(defun tokenize (line)
  (let ((start 0) (len (length line)))
    (loop for s = (position-if #'alphanumericp line :start start)
          while s
          for e = (position-if-not #'alphanumericp line :start (1+ s))
          collect (subseq line s e)
          while (and e (< e len))
          do (setq start e))))

(defun index-file (index filename)
  (with-open-file (in filename)
    (loop for line = (read-line in nil nil)
          while line
          do (dolist (token (tokenize line))
               (pushnew filename (gethash token index '()))))))

(defun build-index (filenames)
  (let ((index (make-hash-table :test #'equal)))
    (dolist (f filenames)
      (index-file index f))
    index))

;; Find the files for QUERY.  We use the same tokenizer for the query
;; as for files.
(defun lookup (index query)
  (remove-duplicates (loop for token in (tokenize query)
                           append (gethash token index))
                     :test #'equal))
