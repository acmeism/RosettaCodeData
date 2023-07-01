(defpackage :avl-tree
  (:use :cl)
  (:export
   :avl-tree
   :make-avl-tree
   :avl-tree-count
   :avl-tree-p
   :avl-tree-key<=
   :gettree
   :remtree
   :clrtree
   :dfs-maptree
   :bfs-maptree))

(in-package :avl-tree)

(defstruct %tree
  key
  value
  (height 0 :type fixnum)
  left
  right)

(defstruct (avl-tree (:constructor %make-avl-tree))
  key<=
  tree
  (count 0 :type fixnum))

(defun make-avl-tree (key<=)
  "Create a new AVL tree using the given comparison function KEY<=
for emplacing keys into the tree."
  (%make-avl-tree :key<= key<=))

(declaim (inline
          recalc-height
          height balance
          swap-kv
          right-right-rotate
          right-left-rotate
          left-right-rotate
          left-left-rotate
          rotate))

(defun recalc-height (tree)
  "Calculate the new height of the tree from the heights of the children."
  (when tree
    (setf (%tree-height tree)
          (1+ (the fixnum (max (height (%tree-right tree))
                               (height (%tree-left tree))))))))

(declaim (ftype (function (t) fixnum) height balance))
(defun height (tree)
  (if tree (%tree-height tree) 0))

(defun balance (tree)
  (if tree
      (- (height (%tree-right tree))
         (height (%tree-left tree)))
      0))

(defmacro swap (place-a place-b)
  "Swap the values of two places."
  (let ((tmp (gensym)))
    `(let ((,tmp ,place-a))
       (setf ,place-a ,place-b)
       (setf ,place-b ,tmp))))

(defun swap-kv (tree-a tree-b)
  "Swap the keys and values of two trees."
  (swap (%tree-value tree-a) (%tree-value tree-b))
  (swap (%tree-key tree-a) (%tree-key tree-b)))

;; We should really use gensyms for the variables in here.
(defmacro slash-rotate (tree right left)
  "Rotate nodes in a slash `/` imbalance."
  `(let* ((a ,tree)
          (b (,right a))
          (c (,right b))
          (a-left (,left a))
          (b-left (,left b)))
     (setf (,right a) c)
     (setf (,left a) b)
     (setf (,left b) a-left)
     (setf (,right b) b-left)
     (swap-kv a b)
     (recalc-height b)
     (recalc-height a)))

(defmacro angle-rotate (tree right left)
  "Rotate nodes in an angle bracket `<` imbalance."
  `(let* ((a ,tree)
          (b (,right a))
          (c (,left b))
          (a-left (,left a))
          (c-left (,left c))
          (c-right (,right c)))
     (setf (,left a) c)
     (setf (,left c) a-left)
     (setf (,right c) c-left)
     (setf (,left b) c-right)
     (swap-kv a c)
     (recalc-height c)
     (recalc-height b)
     (recalc-height a)))

(defun right-right-rotate (tree)
  (slash-rotate tree %tree-right %tree-left))

(defun left-left-rotate (tree)
  (slash-rotate tree %tree-left %tree-right))

(defun right-left-rotate (tree)
  (angle-rotate tree %tree-right %tree-left))

(defun left-right-rotate (tree)
  (angle-rotate tree %tree-left %tree-right))

(defun rotate (tree)
  (declare (type %tree tree))
  "Perform a rotation on the given TREE if it is imbalanced."
  (recalc-height tree)
  (with-slots (left right) tree
    (let ((balance (balance tree)))
      (cond ((< 1 balance) ;; Right imbalanced tree
             (if (<= 0 (balance right))
                 (right-right-rotate tree)
                 (right-left-rotate tree)))
            ((> -1 balance) ;; Left imbalanced tree
             (if (<= 0 (balance left))
                 (left-right-rotate tree)
                 (left-left-rotate tree)))))))

(defun gettree (key avl-tree &optional default)
  "Finds an entry in AVL-TREE whos key is KEY and returns the
associated value and T as multiple values, or returns DEFAULT and NIL
if there was no such entry. Entries can be added using SETF."
  (with-slots (key<= tree) avl-tree
    (labels
        ((rec (tree)
           (if tree
               (with-slots ((t-key key) left right value) tree
                 (if (funcall key<= t-key key)
                     (if (funcall key<= key t-key)
                         (values value t)
                         (rec right))
                     (rec left)))
               (values default nil))))
      (rec tree))))

(defun puttree (value key avl-tree)
  ;;(declare (optimize speed))
  (declare (type avl-tree avl-tree))
  "Emplace the the VALUE with the given KEY into the AVL-TREE, or
overwrite the value if the given key already exists."
  (let ((node (make-%tree :key key :value value)))
    (with-slots (key<= tree count) avl-tree
      (cond (tree
             (labels
                 ((rec (tree)
                    (with-slots ((t-key key) left right) tree
                      (if (funcall key<= t-key key)
                          (if (funcall key<= key t-key)
                              (setf (%tree-value tree) value)
                              (cond (right (rec right))
                                    (t (setf right node)
                                       (incf count))))
                          (cond (left (rec left))
                                (t (setf left node)
                                   (incf count))))
                      (rotate tree))))
               (rec tree)))
            (t (setf tree node)
               (incf count))))
    value))

(defun (setf gettree) (value key avl-tree &optional default)
  (declare (ignore default))
  (puttree value key avl-tree))

(defun remtree (key avl-tree)
  (declare (type avl-tree avl-tree))
  "Remove the entry in AVL-TREE associated with KEY. Return T if
there was such an entry, or NIL if not."
  (with-slots (key<= tree count) avl-tree
    (labels
        ((find-left (tree)
           (with-slots ((t-key key) left right) tree
             (if left
                 (find-left left)
                 tree)))
         (rec (tree &optional parent type)
           (when tree
             (prog1
                 (with-slots ((t-key key) left right) tree
                   (if (funcall key<= t-key key)
                       (cond
                         ((funcall key<= key t-key)
                          (cond
                            ((and left right)
                             (let ((sub-left (find-left right)))
                               (swap-kv sub-left tree)
                               (rec right tree :right)))
                            (t
                             (let ((sub (or left right)))
                               (case type
                                 (:right (setf (%tree-right parent) sub))
                                 (:left (setf (%tree-left parent) sub))
                                 (nil (setf (avl-tree-tree avl-tree) sub))))
                             (decf count)))
                          t)
                         (t (rec right tree :right)))
                       (rec left tree :left)))
               (when parent (rotate parent))))))
      (rec tree))))

(defun clrtree (avl-tree)
  "This removes all the entries from AVL-TREE and returns the tree itself."
  (setf (avl-tree-tree avl-tree) nil)
  (setf (avl-tree-count avl-tree) 0)
  avl-tree)

(defun dfs-maptree (function avl-tree)
  "For each entry in AVL-TREE call the two-argument FUNCTION on
the key and value of each entry in depth-first order from left to right.
Consequences are undefined if AVL-TREE is modified during this call."
  (with-slots (key<= tree) avl-tree
    (labels
        ((rec (tree)
           (when tree
             (with-slots ((t-key key) left right key value) tree
               (rec left)
               (funcall function key value)
               (rec right)))))
      (rec tree))))

(defun bfs-maptree (function avl-tree)
  "For each entry in AVL-TREE call the two-argument FUNCTION on
the key and value of each entry in breadth-first order from left to right.
Consequences are undefined if AVL-TREE is modified during this call."
  (with-slots (key<= tree) avl-tree
    (let* ((queue (cons nil nil))
           (end queue))
      (labels ((pushend (value)
                 (when value
                   (setf (cdr end) (cons value nil))
                   (setf end (cdr end))))
               (empty-p () (eq nil (cdr queue)))
               (popfront ()
                 (prog1 (pop (cdr queue))
                   (when (empty-p) (setf end queue)))))
        (when tree
          (pushend tree)
          (loop until (empty-p)
             do (let ((current (popfront)))
                  (with-slots (key value left right) current
                    (funcall function key value)
                    (pushend left)
                    (pushend right)))))))))

(defun test ()
  (let ((tree (make-avl-tree #'<=))
        (printer (lambda (k v) (print (list k v)))))
    (loop for key in '(0 8 6 4 2 3 7 9 1 5 5)
       for value in '(a b c d e f g h i j k)
       do (setf (gettree key tree) value))
    (loop for key in '(0 1 2 3 4 10)
       do (print (multiple-value-list (gettree key tree))))
    (terpri)
    (print tree)
    (terpri)
    (dfs-maptree printer tree)
    (terpri)
    (bfs-maptree printer tree)
    (terpri)
    (loop for key in '(0 1 2 3 10 7)
       do (print (remtree key tree)))
    (terpri)
    (print tree)
    (terpri)
    (clrtree tree)
    (print tree))
  (values))

(defun profile-test ()
  (let ((tree (make-avl-tree #'<=))
        (randoms (loop repeat 1000000 collect (random 100.0))))
    (loop for key in randoms do (setf (gettree key tree) key))))
