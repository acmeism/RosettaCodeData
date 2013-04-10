(defclass food () ())

(defclass inedible-food (food) ())

(defclass edible-food (food) ())

(defgeneric eat (foodstuff)
  (:documentation "Eat the foodstuff."))

(defmethod eat ((foodstuff edible-food))
  "A specialized method for eating edible-food."
  (format nil "Eating ~w." foodstuff))

(defun eatable-p (thing)
  "Returns true if there are eat methods defined for thing."
  (not (endp (compute-applicable-methods #'eat (list thing)))))

(deftype eatable ()
  "Eatable objects are those satisfying eatable-p."
  '(satisfies eatable-p))

(defun make-food-box (extra-type &rest array-args)
  "Returns an array whose element-type is (and extra-type food).
array-args should be suitable for MAKE-ARRAY, and any provided
element-type keyword argument is ignored."
  (destructuring-bind (dimensions &rest array-args) array-args
    (apply 'make-array dimensions
           :element-type `(and ,extra-type food)
           array-args)))

(defun make-eatable-food-box (&rest array-args)
  "Return an array whose elements are declared to be of type (and
eatable food)."
  (apply 'make-food-box 'eatable array-args))
