(defparameter *w* '((a (a b . 7) (a c . 9) (a f . 14))
                    (b (b c . 10) (b d . 15))
                    (c (c d . 11) (c f . 2))
                    (d (d e . 6))
                    (e (e f . 9))))

(defvar *r* nil)

(defun dijkstra-short-path (i g)
  (setf *r* nil) (paths i g 0 `(,i))
  (car (sort *r* #'< :key #'cadr)))

(defun paths (c g z v)
  (if (eql c g) (push `(,(reverse v) ,z) *r*)
      (loop for a in (nodes c) for b = (cadr a) do
            (unless (member b v)
              (paths b g (+ (cddr a) z) (cons b v))))))

(defun nodes (c)
  (sort (cdr (assoc c *w*)) #'< :key #'cddr))
