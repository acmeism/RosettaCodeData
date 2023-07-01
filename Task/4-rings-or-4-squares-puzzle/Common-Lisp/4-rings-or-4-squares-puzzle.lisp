(defpackage four-rings
  (:use common-lisp)
  (:export display-solutions))
(in-package four-rings)

(defun correct-answer-p (a b c d e f g)
  (let ((v (+ a b)))
    (and (equal v (+ b c d))
         (equal v (+ d e f))
         (equal v (+ f g)))))

(defun combinations-if (func len unique min max)
  (let ((results nil))
    (labels ((inner (cur)
               (if (eql (length cur) len)
                 (when (apply func (reverse cur))
                   (push cur results))
                 (dotimes (i (- max min))
                   (when (or (not unique)
                             (not (member (+ i min) cur)))
                     (inner (append (list (+ i min)) cur)))))))
      (inner nil))
    results))

(defun four-rings-solutions (low high unique)
  (combinations-if #'correct-answer-p 7 unique low (1+ high)))

(defun display-solutions ()
  (let ((letters '((a b c d e f g))))
    (format t "Low 1, High 7, unique letters: ~%~{~{~3A~}~%~}~%"
            (append letters (four-rings-solutions 1 7 t)))
    (format t "Low 3, High 9, unique letters: ~%~{~{~3A~}~%~}~%"
            (append letters (four-rings-solutions 3 9 t)))
    (format t "Number of solutions for Low 0, High 9 non-unique:~%~A~%"
            (length (four-rings-solutions 0 9 nil)))))
