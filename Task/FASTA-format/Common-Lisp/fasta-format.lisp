;; * The input file as a parameter
(defparameter *input* #p"fasta.txt"
              "The input file name.")

;; * Reading the data
(with-open-file (data *input*)
  (loop
     :for line = (read-line data nil nil)
     :while line
     ;; Check if we have a comment using a simple test instead of a RegEx
     :if (char= #\> (char line 0))
     :do (format t "~&~a: " (subseq line 1))
     :else
     :do (format t "~a" line)))
