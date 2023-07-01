(defun rbt-balance (tree)
  (pcase tree
    (`(B (R (R ,a ,x ,b) ,y ,c) ,z ,d) `(R (B ,a ,x ,b) ,y (B ,c ,z ,d)))
    (`(B (R ,a ,x (R ,b ,y ,c)) ,z ,d) `(R (B ,a ,x ,b) ,y (B ,c ,z ,d)))
    (`(B ,a ,x (R (R ,b ,y ,c) ,z ,d)) `(R (B ,a ,x ,b) ,y (B ,c ,z ,d)))
    (`(B ,a ,x (R ,b ,y (R ,c ,z ,d))) `(R (B ,a ,x ,b) ,y (B ,c ,z ,d)))
    (_                                 tree)))

(defun rbt-insert- (x s)
  (pcase s
    (`nil              `(R nil ,x nil))
    (`(,color ,a ,y ,b) (cond ((< x y)
                               (rbt-balance `(,color ,(rbt-insert- x a) ,y ,b)))
                              ((> x y)
                               (rbt-balance `(,color ,a ,y ,(rbt-insert- x b))))
                              (t
                               s)))
    (_                  (error "Expected tree: %S" s))))

(defun rbt-insert (x s)
  (pcase (rbt-insert- x s)
    (`(,_ ,a ,y ,b) `(B ,a ,y ,b))
    (_              (error "Internal error: %S" s))))

(let ((s nil))
  (dotimes (i 16)
    (setq s (rbt-insert (1+ i) s)))
  (pp s))
