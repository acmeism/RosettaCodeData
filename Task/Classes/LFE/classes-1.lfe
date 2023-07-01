(defmodule simple-object
  (export all))

(defun fish-class (species)
  "
  This is the constructor used internally, once the children and fish id are
  known.
  "
  (let ((habitat '"water"))
    (lambda (method-name)
      (case method-name
        ('habitat
          (lambda (self) habitat))
        ('species
          (lambda (self) species))))))

(defun get-method (object method-name)
  "
  This is a generic function, used to call into the given object (class
  instance).
  "
  (funcall object method-name))

; define object methods
(defun get-habitat (object)
  "Get a variable set in the class."
  (funcall (get-method object 'habitat) object))

(defun get-species (object)
  "Get a variable passed when constructing the object."
  (funcall (get-method object 'species) object))
