(mapc #'use-package '(#:toadstool #:toadstool-system))
(defstruct (red-black-tree (:constructor tree (color left val right)))
  color left val right)

(defcomponent tree (operator macro-mixin))
(defexpand tree (color left val right)
  `(class red-black-tree red-black-tree-color ,color
                         red-black-tree-left ,left
                         red-black-tree-val ,val
                         red-black-tree-right ,right))
(pushnew 'tree *used-components*)

(defun balance (color left val right)
  (toad-ecase (color left val right)
    (('black (tree 'red (tree 'red a x b) y c) z d)
     (tree 'red (tree 'black a x b) y
           (tree 'black c z d)))
    (('black (tree 'red a x (tree 'red b y c)) z d)
     (tree 'red (tree 'black a x b) y (tree 'black c z d)))
    (('black a x (tree 'red (tree 'red b y c) z d))
     (tree 'red (tree 'black a x b) y (tree 'black c z d)))
    (('black a x (tree 'red b y (tree 'red c z d)))
     (tree 'red (tree 'black a x b) y (tree 'black c z d)))
    ((color a x b)
     (tree color a x b))))

(defun %insert (x s)
  (toad-ecase1 s
    (nil (tree 'red nil x nil))
    ((tree color a y b)
     (cond ((< x y)
            (balance color (%insert x a) y b))
           ((> x y)
            (balance color a y (%insert x b)))
           (t s)))))

(defun insert (x s)
  (toad-ecase1 (%insert x s)
    ((tree t a y b) (tree 'black a y b))))
