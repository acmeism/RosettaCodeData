(defun plausibility (rule-name examples counter-examples)
  (let ((plausible (if (> examples (* 2 counter-examples))
                       'plausible 'not-plausible)))
    (format t "The rule \"~a\" is ~S. There were ~a examples and ~a counter-examples.~%"
            rule-name plausible examples counter-examples)
    plausible))

(with-open-file (stream #p"unixdict.txt")
  (let ((cei 0) (cie 0) (ie 0) (ei 0))
    (macrolet ((search-counter (&rest terms)
                 (when terms
                   `(progn
                      (when (search ,(string-downcase (symbol-name (car terms))) line)
                        (incf ,(car terms)))
                      (search-counter ,@(cdr terms))))))
      (do ((line (read-line stream nil) (read-line stream nil)))
          ((null line))
        (search-counter cei cie ie ei)))
    (flet ((plausible-p (&rest results)
             (or (car (member 'not-plausible results)) 'plausible)))
      (format t "~%~%Overall the rule is ~S~%"
              (plausible-p (plausibility "I before E when not preceded by C" (- ie cie) (- ei cei))
                           (plausibility "E before I when preceded by C" cei cie))))))
