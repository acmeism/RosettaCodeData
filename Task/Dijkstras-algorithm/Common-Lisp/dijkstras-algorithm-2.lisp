(defvar *r* nil)

(defun dijkstra-short-paths (z w)
  (loop for (a b) in (loop for v on z nconc
                           (loop for e in (cdr v)
                                 collect `(,(car v) ,e)))
        do (setf *r* nil) (paths w a b 0 `(,a))
        (format t "~{Path: ~A  Distance: ~A~}~%"
                (car (sort *r* #'< :key #'cadr)))))

(defun paths (w c g z v)
  (if (eql c g) (push `(,(reverse v) ,z) *r*)
      (loop for a in (sort (cdr (assoc c w)) #'< :key #'cddr)
            for b = (cadr a) do (unless (member b v)
                                  (paths w b g (+ (cddr a) z)
                                         (cons b v))))))
