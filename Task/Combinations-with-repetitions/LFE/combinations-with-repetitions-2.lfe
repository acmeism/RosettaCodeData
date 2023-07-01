(defun combinations
  (('() _)
    '())
  ((coll 1)
    (lists:map #'list/1 coll))
   (((= (cons head tail) coll) n)
    (++ (lists:map (lambda (subcoll) (cons head subcoll))
                   (combinations coll (- n 1)))
        (combinations tail n))))
