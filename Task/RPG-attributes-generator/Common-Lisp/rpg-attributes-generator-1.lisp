(defpackage :rpg-generator
  (:use :cl)
  (:export :generate))
(in-package :rpg-generator)
(defun sufficient-scores-p (scores)
  (and (>= (apply #'+ scores) 75)
       (>= (count-if #'(lambda (n) (>= n 15)) scores) 2)))

(defun gen-score ()
  (apply #'+ (rest (sort (loop repeat 4 collect (1+ (random 6))) #'<))))

(defun generate ()
  (loop for scores = (loop repeat 6 collect (gen-score))
        until (sufficient-scores-p scores)
        finally (format t "Scores: ~A~%" scores)
                (format t "Total: ~A~%" (apply #'+ scores))
                (format t ">= 15: ~A~%" (count-if (lambda (n) (>= n 15)) scores))
                (return scores)))
