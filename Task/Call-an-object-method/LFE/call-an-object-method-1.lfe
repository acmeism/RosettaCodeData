(defmodule aquarium
 (export all))

(defun fish-class (species)
  "
  This is the constructor that will be used most often, only requiring that
  one pass a 'species' string.

  When the children are not defined, simply use an empty list.
  "
  (fish-class species ()))

(defun fish-class (species children)
  "
  This contructor is mostly useful as a way of abstracting out the id
  generation from the larger constructor. Nothing else uses fish-class/2
  besides fish-class/1, so it's not strictly necessary.

  When the id isn't know, generate one.
  "
  (let* (((binary (id (size 128))) (: crypto rand_bytes 16))
         (formatted-id (car
                         (: io_lib format
                           '"~32.16.0b" (list id)))))
    (fish-class species children formatted-id)))

(defun fish-class (species children id)
  "
  This is the constructor used internally, once the children and fish id are
  known.
  "
  (let ((move-verb '"swam"))
    (lambda (method-name)
      (case method-name
        ('id
          (lambda (self) id))
        ('species
          (lambda (self) species))
        ('children
          (lambda (self) children))
        ('info
          (lambda (self)
            (: io format
              '"id: ~p~nspecies: ~p~nchildren: ~p~n"
              (list (get-id self)
                    (get-species self)
                    (get-children self)))))
        ('move
          (lambda (self distance)
            (: io format
              '"The ~s ~s ~p feet!~n"
              (list species move-verb distance))))
        ('reproduce
          (lambda (self)
            (let* ((child (fish-class species))
                   (child-id (get-id child))
                   (children-ids (: lists append
                                   (list children (list child-id))))
                   (parent-id (get-id self))
                   (parent (fish-class species children-ids parent-id)))
              (list parent child))))
        ('children-count
          (lambda (self)
            (: erlang length children)))))))

(defun get-method (object method-name)
  "
  This is a generic function, used to call into the given object (class
  instance).
  "
  (funcall object method-name))

; define object methods
(defun get-id (object)
  (funcall (get-method object 'id) object))

(defun get-species (object)
  (funcall (get-method object 'species) object))

(defun get-info (object)
  (funcall (get-method object 'info) object))

(defun move (object distance)
  (funcall (get-method object 'move) object distance))

(defun reproduce (object)
  (funcall (get-method object 'reproduce) object))

(defun get-children (object)
  (funcall (get-method object 'children) object))

(defun get-children-count (object)
  (funcall (get-method object 'children-count) object))
