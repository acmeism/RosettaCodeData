(defvar *self*)

(defclass queue ()
  ((condition :initform (make-condition-variable)
              :reader condition-of)
   (mailbox :initform '()
            :accessor mailbox-of)
   (lock :initform (make-lock)
         :reader lock-of)))

(defun message (recipient name &rest message)
  (with-lock-held ((lock-of recipient))
    ;; it would have been better to implement tail-consing or a LIFO
    (setf (mailbox-of recipient)
          (nconc (mailbox-of recipient)
                 (list (list* name message))))
    (condition-notify (condition-of recipient)))
  message)

(defun mklist (x)
  (if (listp x)
      x
      (list x)))

(defun slurp-message ()
  (with-lock-held ((lock-of *self*))
    (if (not (endp (mailbox-of *self*)))
        (pop (mailbox-of *self*))
        (progn (condition-wait (condition-of *self*)
                               (lock-of *self*))
               (assert (not (endp (mailbox-of *self*))))
               (pop (mailbox-of *self*))))))

(defmacro receive-message (&body cases)
  (let ((msg-name (gensym "MESSAGE"))
        (block-name (gensym "BLOCK")))
    `(let ((,msg-name (slurp-message)))
       (block ,block-name
         ,@(loop for i in cases
                 for ((name . case) . body) = (cons (mklist (car i))
                                                    (cdr i))
                 when (typep i '(or (cons (eql quote)
                                          t)
                                    (cons (cons (eql quote) t)
                                          t)))
                   do (warn "~S is a quoted form" i)
                 collect `(when ,(if (null name)
                                     't
                                     `(eql ',name (car ,msg-name)))
                            (destructuring-bind ,case
                                (cdr ,msg-name)
                              (return-from ,block-name
                                (progn ,@body)))))
         (error "Unknown message: ~S" ,msg-name)))))

(defmacro receive-one-message (message &body body)
  `(receive-message (,message . ,body)))

(defun queue () (make-instance 'queue))
