(defmodule object
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
  This constructor is useful for two reasons:
    1) as a way of abstracting out the id generation from the
       larger constructor, and
    2) spawning the 'object loop' code (fish-class/3).
  "
  (let* (((binary (id (size 128))) (: crypto rand_bytes 16))
         (formatted-id (car
                         (: io_lib format
                           '"~32.16.0b" (list id)))))
    (spawn 'object
           'fish-class
           (list species children formatted-id))))

(defun fish-class (species children id)
  "
  This function is intended to be spawned as a separate process which is
  used to track the state of a fish. In particular, fish-class/2 spawns
  this function (which acts as a loop, pattern matching for messages).
  "
  (let ((move-verb '"swam"))
    (receive
      ((tuple caller 'move distance)
        (! caller (list species move-verb distance))
        (fish-class species children id))
      ((tuple caller 'species)
        (! caller species)
        (fish-class species children id))
      ((tuple caller 'children)
        (! caller children)
        (fish-class species children id))
      ((tuple caller 'children-count)
        (! caller (length children))
        (fish-class species children id))
      ((tuple caller 'id)
        (! caller id)
        (fish-class species children id))
      ((tuple caller 'info)
        (! caller (list id species children))
        (fish-class species children id))
      ((tuple caller 'reproduce)
        (let* ((child (fish-class species))
               (child-id (get-id child))
               (children-ids (: lists append
                               (list children (list child-id)))))
        (! caller child)
        (fish-class species children-ids id))))))

(defun call-method (object method-name)
  "
  This is a generic function, used to call into the given object (class
  instance).
  "
  (! object (tuple (self) method-name))
  (receive
    (data data)))

(defun call-method (object method-name arg)
  "
  Same as above, but with an additional argument.
  "
  (! object (tuple (self) method-name arg))
  (receive
    (data data)))

; define object methods
(defun get-id (object)
  (call-method object 'id))

(defun get-species (object)
  (call-method object 'species))

(defun get-info (object)
  (let ((data (call-method object 'info)))
    (: io format '"id: ~s~nspecies: ~s~nchildren: ~p~n" data)))

(defun move (object distance)
  (let ((data (call-method object 'move distance)))
    (: io format '"The ~s ~s ~p feet!~n" data)))

(defun reproduce (object)
  (call-method object 'reproduce))

(defun get-children (object)
  (call-method object 'children))

(defun get-children-count (object)
  (call-method object 'children-count))
