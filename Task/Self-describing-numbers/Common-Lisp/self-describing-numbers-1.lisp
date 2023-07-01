(defun to-ascii (str) (mapcar #'char-code (coerce str 'list)))

(defun to-digits (n)
  (mapcar #'(lambda(v) (- v 48)) (to-ascii  (princ-to-string n))))

(defun count-digits (n)
  (do
      ((counts (make-array '(10) :initial-contents '(0 0 0 0 0 0 0 0 0 0)))
       (curlist (to-digits n) (cdr curlist)))
      ((null curlist) counts)
    (setf (aref counts (car curlist)) (+ 1 (aref counts (car curlist)))))))

(defun self-described-p (n)
  (if (not (numberp n))
      nil
  (do ((counts (count-digits n))
       (ipos 0 (+ 1 ipos))
       (digits (to-digits n) (cdr digits)))
      ((null digits) t)
    (if (not (eql (car digits) (aref counts ipos))) (return nil)))))
