(defun preorder (node f)
  (when node
    (funcall f (first node))
    (preorder (second node) f)
    (preorder (third node)  f)))

(defun inorder (node f)
  (when node
    (inorder (second node) f)
    (funcall f (first node))
    (inorder (third node)  f)))

(defun postorder (node f)
  (when node
    (postorder (second node) f)
    (postorder (third node)  f)
    (funcall f (first node))))

(defun level-order (node f)
  (loop with level = (list node)
        while level
        do
    (setf level (loop for node in level
                      when node
                        do (funcall f (first node))
                        and collect (second node)
                        and collect (third node)))))

(defparameter *tree* '(1 (2 (4 (7))
                            (5))
                         (3 (6 (8)
                               (9)))))

(defun show (traversal-function)
  (format t "~&~(~A~):~12,0T" traversal-function)
  (funcall traversal-function *tree* (lambda (value) (format t " ~A" value))))

(map nil #'show '(preorder inorder postorder level-order))
