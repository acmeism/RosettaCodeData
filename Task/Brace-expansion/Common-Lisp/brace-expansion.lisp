(defstruct alternation
  (alternatives nil :type list))

(defun alternatives-end-positions (string start)
  (assert (char= (char string start) #\{))
  (loop with level = 0
        with end-positions
        with escapep and commap
        for index from start below (length string)
        for c = (char string index)
        do (cond (escapep
                  (setf escapep nil))
                 ((char= c #\\)
                  (setf escapep t))
                 ((char= c #\{)
                  (incf level))
                 ((char= c #\})
                  (decf level)
                  (when (zerop level)
                    (push index end-positions)
                    (loop-finish)))
                 ((and (char= c #\,) (= level 1))
                  (setf commap t)
                  (push index end-positions)))
        finally (return (and (zerop level) commap (nreverse end-positions)))))

(defun parse-alternation (string start)
  (loop with end-positions = (alternatives-end-positions string start)
        for %start = (1+ start) then (1+ %end)
        for %end in end-positions
        collect (parse string :start %start :end %end) into alternatives
        finally (return (and alternatives
                             (values (make-alternation :alternatives alternatives) (1+ %end))))))

(defun parse (string &key (start 0) (end (length string)))
  (loop with result and escapep
        for index = start then next
        while (< index end)
        for c = (char string index)
        for next = (1+ index)
        do (cond (escapep
                  (push c result)
                  (setf escapep nil))
                 ((char= c #\\)
                  (push c result)
                  (setf escapep t))
                 ((char= c #\{)
                  (multiple-value-bind (alternation next-index)
                      (parse-alternation string index)
                    (cond (alternation
                           (push alternation result)
                           (setf next next-index))
                          (t
                           (push c result)))))
                 (t
                  (push c result)))
        finally (return (nreverse result))))

(defun traverse-alternation (alternation)
  (mapcan #'traverse (alternation-alternatives alternation)))

(defun traverse (parsed)
  (let ((results (list nil)))
    (dolist (element parsed results)
      (etypecase element
        (character
         (setf results (loop for r in results
                             collect (nconc r (list element)))))
        (alternation
         (setf results (loop for r in results
                             nconc (loop for ar in (traverse-alternation element)
                                         collect (append r ar)))))))))

(defun expand (string)
  (loop for result in (traverse (parse string))
        collect (coerce result 'string)))

(defun main ()
  (dolist (input '("~/{Downloads,Pictures}/*.{jpg,gif,png}"
                   "It{{em,alic}iz,erat}e{d,}, please."
                   "{,{,gotta have{ ,\\, again\\, }}more }cowbell!"
                   "{}} some }{,{\\\\{ edge, edge} \\,}{ cases, {here} \\\\\\\\\\}"))
    (write-line input)
    (dolist (output (expand input))
      (format t "    ~A~%" output))
    (terpri)))
