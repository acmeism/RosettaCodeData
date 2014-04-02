(defgeneric monadic-map (monad-class function))

(defgeneric monadic-join (monad-class container-of-containers &rest additional))

(defgeneric monadic-instance (monad-class-name))

(defmacro comprehend (monad-instance expr &rest clauses)
  (let ((monad-var (gensym "CLASS-")))
    (cond
      ((null clauses) `(multiple-value-call #'monadic-unit
                         ,monad-instance ,expr))
      ((rest clauses) `(let ((,monad-var ,monad-instance))
                         (multiple-value-call #'monadic-join ,monad-var
                           (comprehend ,monad-var
                             (comprehend ,monad-var ,expr ,@(rest clauses))
                             ,(first clauses)))))
      (t (destructuring-bind (var &rest container-exprs) (first clauses)
           (cond
             ((and var (symbolp var))
              `(funcall (monadic-map ,monad-instance (lambda (,var) ,expr))
                        ,(first container-exprs)))
             ((and (consp var) (every #'symbolp var))
              `(multiple-value-call (monadic-map ,monad-instance
                                                 (lambda (,@var) ,expr))
                                     ,@container-exprs))
             (t (error "COMPREHEND: bad variable specification: ~s" vars))))))))

(defmacro define-monad (class-name
                        &key comprehension
                             (monad-param (gensym "MONAD-"))
                             bases slots initargs
                              ((:map ((map-param)
                                      &body map-body)))
                              ((:join ((join-param
                                        &optional
                                          (j-rest-kw '&rest)
                                          (j-rest (gensym "JOIN-REST-")))
                                        &body join-body)))
                              ((:unit ((unit-param
                                        &optional
                                          (u-rest-kw '&rest)
                                          (u-rest (gensym "UNIT-REST-")))
                                       &body unit-body))))
  `(progn
     (defclass ,class-name ,bases ,slots)
     (defmethod monadic-instance ((monad (eql ',class-name)))
       (load-time-value (make-instance ',class-name ,@initargs)))
     (defmethod monadic-map ((,monad-param ,class-name) ,map-param)
       (declare (ignorable ,monad-param))
       ,@map-body)
     (defmethod monadic-join ((,monad-param ,class-name)
                              ,join-param &rest ,j-rest)
       (declare (ignorable ,monad-param ,j-rest))
       ,@join-body)
     (defmethod monadic-unit ((,monad-param ,class-name)
                              ,unit-param &rest ,u-rest)
       (declare (ignorable ,monad-param ,u-rest))
       ,@unit-body)
     ,@(if comprehension
         `((defmacro ,comprehension (expr &rest clauses)
             `(comprehend (monadic-instance ',',class-name)
                          ,expr  ,@clauses))))))

(defmethod monadic-map ((monad symbol) function)
  (monadic-map (monadic-instance monad) function))

(defmethod monadic-join ((monad symbol) container-of-containers &rest rest)
  (apply #'monadic-join (monadic-instance monad) container-of-containers rest))

(defmethod monadic-unit ((monad symbol) element &rest rest)
  (apply #'monadic-unit (monadic-instance monad) element rest))

(define-monad list-monad
  :comprehension list-comp
  :map ((function) (lambda (container) (mapcar function container)))
  :join ((list-of-lists) (reduce #'append list-of-lists))
  :unit ((element) (list element)))

(define-monad identity-monad
  :comprehension identity-comp
  :map ((f) f)
  :join ((x &rest rest) (apply #'values x rest))
  :unit ((x &rest rest) (apply #'values x rest)))

(define-monad state-xform-monad
  :comprehension state-xform-comp
  :map ((f)
          (lambda (xformer)
            (lambda (s)
               (identity-comp (values (funcall f x) new-state)
                              ((x new-state) (funcall xformer s))))))
  :join ((nested-xformer)
           (lambda (s)
             (identity-comp (values x new-state)
                            ((embedded-xformer intermediate-state)
                             (funcall nested-xformer s))
                            ((x new-state)
                             (funcall embedded-xformer intermediate-state)))))
  :unit ((x) (lambda (s) (values x s))))
