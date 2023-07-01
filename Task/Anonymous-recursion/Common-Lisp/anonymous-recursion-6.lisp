(setf (symbol-function '!)  (symbol-function 'funcall)
      (symbol-function '!!) (symbol-function 'apply))

(defmacro ? (args &body body)
  `(lambda ,args ,@body))

(defstruct combinator
  (name     nil :type symbol)
  (function nil :type function))

(defmethod print-object ((combinator combinator) stream)
  (print-unreadable-object (combinator stream :type t)
    (format stream "~A" (combinator-name combinator))))

(defconstant +y-combinator+
  (make-combinator
   :name     'y-combinator
   :function (? (f) (! (? (g) (! g g))
                       (? (g) (! f (? (&rest a)
                                     (!! (! g g) a))))))))

(defconstant +z-combinator+
  (make-combinator
   :name     'z-combinator
   :function (? (f) (! (? (g) (! f (? (x) (! (! g g) x))))
                       (? (g) (! f (? (x) (! (! g g) x))))))))

(defparameter *default-combinator* +y-combinator+)

(defmacro with-y-combinator (&body body)
  `(let ((*default-combinator* +y-combinator+))
     ,@body))

(defmacro with-z-combinator (&body body)
  `(let ((*default-combinator* +z-combinator+))
     ,@body))

(defun x-call (x-function &rest args)
  (apply (funcall (combinator-function *default-combinator*) x-function) args))

(defmacro x-function ((name &rest args) &body body)
  `(lambda (,name)
     (lambda ,args
       (macrolet ((,name (&rest args)
                    `(funcall ,',name ,@args)))
         ,@body))))

(defmacro x-defun (name args &body body)
  `(defun ,name ,args
     (x-call (x-function (,name ,@args) ,@body) ,@args)))

;;;; examples

(x-defun factorial (n)
  (if (zerop n)
      1
      (* n (factorial (1- n)))))

(x-defun fib (n)
  (case n
    (0 0)
    (1 1)
    (otherwise (+ (fib (- n 1))
                  (fib (- n 2))))))
