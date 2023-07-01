;; 22.11.18  Ajout macro

(defvar *stack* nil)
(defvar *assert* t)

(defun ambnew ()
  (setf *stack* nil)
  (setf *assert* t))

(defmacro ambsel (name domain)
  `(progn (defparameter ,name (first ,domain))
          (pushnew ',name *stack*)
          (setf (get ',name 'domain) ,domain)))

(defun ambassert (assert)
  (setf *assert* (list 'and assert *assert*))
  (if (eval *assert*)
      t
      (labels ((probe (&optional (stack *stack*))
                 (let* ((name (first stack))
                        (domain (get name 'domain)))
                   (dolist (value domain)
                     (set name value)
                     (cond ((eval *assert*) (return t))
                           ((probe (rest stack)) (return t)))))))
               (probe))))
