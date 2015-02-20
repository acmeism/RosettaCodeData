(defun split-and-reverse (str)
  (labels
    ((iter (s lst)
       (let ((s2 (string-trim '(#\space) s)))
         (if s2
             (let ((word-end (position #\space s2)))
               (if (and word-end (< (1+ word-end) (length s2)))
                   (iter (subseq s2 (1+ word-end))
                         (cons (subseq s2 0 word-end) lst))
                   (cons s2 lst)))
               lst))))
  (iter str NIL)))

(defparameter *poem*
  "---------- Ice and Fire ------------

   fire, in end will world the say Some
   ice. in say Some
   desire of tasted I've what From
   fire. favor who those with hold I

   ... elided paragraph last ...

   Frost Robert -----------------------")

(with-input-from-string (s *poem*)
  (loop for line = (read-line s NIL)
        while line
        do (format t "~{~a~#[~:; ~]~}~%" (split-and-reverse line))))
