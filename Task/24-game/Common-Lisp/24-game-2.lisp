(defconstant +ops+ '(* / + -))

(defun expr-numbers (e &optional acc)
  "Return all the numbers in argument positions in the expression."
  (cond
   ((numberp e) (cons e acc))
   ((consp e)
    (append (apply #'append
                   (mapcar #'expr-numbers (cdr e)))
            acc))))

(defun expr-well-formed-p (e)
  "Return non-nil if the given expression is well-formed."
  (cond
   ((numberp e) t)
   ((consp e)
    (and (member (car e) +ops+)
         (every #'expr-well-formed-p (cdr e))))
   (t nil)))

(defun expr-valid-p (e available-digits)
  "Return non-nil if the expression is well-formed and uses exactly
the digits specified."
  (and (expr-well-formed-p e)
       (equalp (sort (copy-seq available-digits) #'<)
               (sort (expr-numbers e) #'<))))

(defun expr-get (&optional using)
  (emit "Enter lisp form~@[ using the digit~P ~{~D~^ ~}~]: "
        (when using
          (length using)) using)
  (let (*read-eval*)
    (read)))

(defun digits ()
  (sort (loop repeat 4 collect (1+ (random 9))) #'<))

(defun emit (fmt &rest args)
  (format t "~&~?" fmt args))

(defun prompt (digits)
  (emit "Using only these operators:~%~%~
           ~2T~{~A~^ ~}~%~%~
         And exactly these numbers \(no repetition\):~%~%~
           ~2T~{~D~^ ~}~%~%~
         ~A"
        +ops+ digits (secondary-prompt)))

(defun secondary-prompt ()
  (fill-to 50 "Enter a lisp form which evaluates to ~
               the integer 24, or \"!\" to get fresh ~
               digits, or \"q\" to abort."))

(defun fill-to (n fmt &rest args)
  "Poor-man's text filling mechanism."
  (loop with s = (format nil "~?" fmt args)
        for c across s
        and i from 0
        and j = 0 then (1+ j) ; since-last-newline ctr

        when (char= c #\Newline)
        do (setq j 0)

        else when (and (not (zerop j))
                       (zerop (mod j n)))
        do (loop for k from i below (length s)
                 when (char= #\Space (schar s k))
                 do (progn
                      (setf (schar s k) #\Newline
                            j 0)
                      (loop-finish)))
        finally (return s)))

(defun 24-game ()
  (loop with playing-p = t
        and initial-digits = (digits)

        for attempts from 0
        and digits = initial-digits then (digits)

        while playing-p

        do (loop for e = (expr-get (unless (zerop attempts)
                                     digits))
                 do
                 (case e
                   (! (loop-finish))
                   (Q (setq playing-p nil)
                      (loop-finish))
                   (R (emit "Current digits: ~S" digits))
                   (t
                    (if (expr-valid-p e digits)
                        (let ((v (eval e)))
                          (if (eql v 24)
                              (progn
                                (emit "~%~%---> A winner is you! <---~%~%")
                                (setq playing-p nil)
                                (loop-finish))
                            (emit "Sorry, the form you entered ~
                                   computes to ~S, not 24.~%~%"
                                  v)))
                      (emit "Sorry, the form you entered did not ~
                             compute.~%~%")))))
        initially (prompt initial-digits)))
