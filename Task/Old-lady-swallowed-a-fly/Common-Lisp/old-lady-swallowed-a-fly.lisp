(defun verse  (what remark &optional always die) (list what remark always die))
(defun what   (verse) (first verse))
(defun remark (verse) (second verse))
(defun always (verse) (third verse))
(defun die    (verse) (fourth verse))

(defun ssa (what remark &optional always die )
    (verse what (format nil "~a she swallowed a ~a!" remark what always die)))
(defun tsa (what remark &optional always die)
    (verse what (format nil "~a, to swallow a ~a!" remark what)))
(defun asa (what remark &optional always die)
    (verse what (format nil "~a, and swallowed a ~a!" remark what)))


(let ((verses (list
        (verse "fly" "I don't know why she swallowed the fly" T)
        (verse "spider" "That wriggled and jiggled and tickled inside her" T)
        (tsa   "bird" "Now how absurd")
        (tsa   "cat" "Now fancy that")
        (tsa   "dog" "what a hog")
        (asa   "goat" "She just opened her throat")
        (ssa   "cow" "I don't know how")
        (verse "horse" "She's dead, of course!" T T))))

  (loop for verse in verses for i from 0 doing
    (let ((it (what verse)))
      (format t "I know an old lady who swallowed a ~a~%" it)
      (format t "~a~%" (remark verse))
      (if (not (die verse)) (progn
        (if (> i 0)
          (loop for j from (1- i) downto 0 doing
            (let* ((v (nth j verses)))
              (format t "She swallowed the ~a to catch the ~a~%" it (what v))
              (setf it (what v))
              (if (always v)
                (format t "~a~a~%" (if (= j 0) "But " "") (remark v))))))
        (format t "Perhaps she'll die. ~%~%"))))))
