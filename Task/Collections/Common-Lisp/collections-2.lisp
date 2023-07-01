;;; Obtained from Usenet,
;;; Message-ID: <b3b1cc90-2e2b-43c3-b7d9-785ae29870e7@e23g2000prf.googlegroups.com>
;;; Posting by Kaz Kylheku, February 28, 2008.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defun bisect-list (list &optional (minimum-length 0))
    (do ((double-skipper (cddr list) (cddr double-skipper))
         (single-skipper list (cdr single-skipper))
         (length 2 (+ length (if (cdr double-skipper) 2 1))))
      ((null double-skipper)
       (cond
         ((< length minimum-length)
          (values list nil))
         ((consp single-skipper)
          (multiple-value-prog1
            (values list (cdr single-skipper))
            (setf (cdr single-skipper) nil)))
         (t (values list nil))))))

  (defun pop-deque-helper (facing-piece other-piece)
    (if (null facing-piece)
      (multiple-value-bind (head tail) (bisect-list other-piece 10)
        (let ((remaining (if tail head))
              (moved (nreverse (or tail head))))
          (values (first moved) (rest moved) remaining)))
      (values (first facing-piece) (rest facing-piece) other-piece))))

(defmacro pop-deque (facing-piece other-piece)
  (let ((result (gensym))
        (new-facing (gensym))
        (new-other (gensym)))
    `(multiple-value-bind (,result ,new-facing ,new-other)
                          (pop-deque-helper ,facing-piece ,other-piece)
       (psetf ,facing-piece ,new-facing
              ,other-piece ,new-other)
       ,result)))
