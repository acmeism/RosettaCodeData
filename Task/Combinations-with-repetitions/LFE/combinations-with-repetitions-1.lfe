(defun combinations
 (('() _)
    '())
  ((coll 1)
    (lists:map #'list/1 coll))
   (((= (cons head tail) coll) n)
    (++ (lc ((<- subcoll (combinations coll (- n 1))))
            (cons head subcoll))
        (combinations tail n))))
