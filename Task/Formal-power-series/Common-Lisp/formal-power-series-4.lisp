(defun invoke-with-lons (function lons)
  (funcall function (lar lons) (ldr lons)))

(defmacro with-lons ((lar ldr) lons &body body)
  `(invoke-with-lons #'(lambda (,lar ,ldr) ,@body) ,lons))

(defun maplar (function llist &rest llists)
  (let ((llists (list* llist llists)))
    (if (some 'null llists) nil
      (lons (apply function (cl:mapcar 'lar llists))
            (apply 'maplar function (cl:mapcar 'ldr llists))))))

(defun take (n llist)
  (if (zerop n) '()
    (lons (lar llist)
          (take (1- n) (ldr llist)))))

(defun force-list (llist)
  (do ((fl '() (cons (lar l) fl))
       (l llist (ldr l)))
      ((null l) (nreverse fl))))

(defun repeat (x)
  (lons x (repeat x)))

(defun up-from (n)
  (lons n (up-from (1+ n))))
