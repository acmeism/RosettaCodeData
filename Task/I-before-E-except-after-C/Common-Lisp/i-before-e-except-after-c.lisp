(defun test-rule (rule-name examples counter-examples)
  (let ((plausible (if (> examples (* 2 counter-examples)) 'plausible 'not-plausible)))
    (list rule-name plausible examples counter-examples)))

(defun plausibility (result-string file parser)
  (let ((cei 0) (cie 0) (ie 0) (ei 0))
    (macrolet ((search-count (&rest terms)
                 (when terms
                   `(progn
                      (when (search ,(string-downcase (symbol-name (car terms))) word)
                        (incf ,(car terms) freq))
                      (search-count ,@(cdr terms))))))
      (with-open-file (stream file :external-format :latin-1)
        (loop :for raw-line = (read-line stream nil 'eof)
              :until (eq raw-line 'eof)
              :for line = (string-trim '(#\Tab #\Space) raw-line)
              :for (word freq) = (funcall parser line)
              :do (search-count cei cie ie ei))
        (print-result result-string cei cie ie ei)))))

(defun print-result (result-string cei cie ie ei)
  (let ((results (list (test-rule "I before E when not preceded by C" (- ie cie) (- ei cei))
                       (test-rule "E before I when preceded by C" cei cie))))
    (format t "~a:~%~{~{~2TThe rule \"~a\" is ~S. There were ~a examples and ~a counter-examples.~}~^~%~}~%~%~2TOverall the rule is ~S~%~%"
            result-string results (or (find 'not-plausible (mapcar #'cadr results)) 'plausible))))

(defun parse-dict (line) (list line 1))

(defun parse-freq (line)
  (list (subseq line 0 (position #\Tab line))
        (parse-integer (subseq line (position #\Tab line :from-end t)) :junk-allowed t)))

(plausibility "Dictionary" #p"unixdict.txt" #'parse-dict)
(plausibility "Word frequencies (stretch goal)" #p"1_2_all_freq.txt" #'parse-freq)
