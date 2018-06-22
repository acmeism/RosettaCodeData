(in-package :common-lisp-user)

;;
;; FLAG -- if using quicklisp, you can get bordeaux-threads loaded up
;; with: (ql:quickload :bordeaux-threads)
;;

(defvar *philosophers* '(Aristotle Kant Spinoza Marx Russell))

(defclass philosopher ()
  ((name :initarg :name :reader name-of)
   (left-fork :initarg :left-fork :accessor left-fork-of)
   (right-fork :initarg :right-fork :accessor right-fork-of)
   (meals-left :initarg :meals-left :accessor meals-left-of)))

(defclass fork ()
  ((lock :initform (bt:make-lock "fork") :reader lock-of)))

(defun random-normal (&optional (mean 0.0) (sd 1.0))
  (do* ((x1 #1=(1- (* 2.0d0 (random 1d0))) #1#)
        (x2 #2=(1- (* 2.0d0 (random 1d0))) #2#)
        (w  #3=(+ (* x1 x1) (* x2 x2)) #3#))
      ((< w 1d0) (+ (* (* x1 (sqrt (/ (* -2d0 (log w)) w))) sd) mean))))

(defun sleep* (time) (sleep (max time (/ (expt 10 7)))))

(defun dining-philosophers (&key (philosopher-names *philosophers*)
                                 (meals 30)
                                 (dining-time'(1 2))
                                 (thinking-time '(1 2))
                                 ((stream e) *error-output*))
  (let* ((count (length philosopher-names))
         (forks (loop repeat count collect (make-instance 'fork)))
         (philosophers (loop for i from 0
                             for name in philosopher-names collect
                               (make-instance 'philosopher
                                    :left-fork (nth (mod i count) forks)
                                    :right-fork (nth (mod (1+ i) count) forks)
                                    :name name
                                    :meals-left meals)))
         (condition (bt:make-condition-variable))
         (lock (bt:make-lock "main loop"))
         (output-lock (bt:make-lock "output lock")))
    (dolist (p philosophers)
      (labels ((think ()
                 (/me "is now thinking")
                 (sleep* (apply #'random-normal thinking-time))
                 (/me "is now hungry")
                 (dine))
               (dine ()
                 (bt:with-lock-held ((lock-of (left-fork-of p)))
                   (or (bt:acquire-lock (lock-of (right-fork-of p)) nil)
                       (progn (/me "couldn't get a fork and ~
                                    returns to thinking")
                              (bt:release-lock (lock-of (left-fork-of p)))
                              (return-from dine (think))))
                   (/me "is eating")
                   (sleep* (apply #'random-normal dining-time))
                   (bt:release-lock (lock-of (right-fork-of p)))
                   (/me "is done eating (~A meals left)"
                        (decf (meals-left-of p))))
                 (cond ((<= (meals-left-of p) 0)
                        (/me "leaves the dining room")
                        (bt:with-lock-held (lock)
                          (setq philosophers (delete p philosophers))
                          (bt:condition-notify condition)))
                       (t (think))))
               (/me (control &rest args)
                 (bt:with-lock-held (output-lock)
                   (write-sequence (string (name-of p)) e)
                   (write-char #\Space e)
                   (apply #'format e (concatenate 'string control "~%")
                          args))))
        (bt:make-thread #'think)))
    (loop (bt:with-lock-held (lock)
            (when (endp philosophers)
              (format e "all philosophers are done dining~%")
              (return)))
          (bt:with-lock-held (lock)
            (bt:condition-wait condition lock)))))
