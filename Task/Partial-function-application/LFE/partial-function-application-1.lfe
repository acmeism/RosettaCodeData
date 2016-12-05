(defun partial
  "The partial function is arity 2 where the first parameter must be a
  function and the second parameter may either be a single item or a list of
  items.

  When funcall is called against the result of the partial call, a second
  parameter is applied to the partial function. This parameter too may be
  either a single item or a list of items."
  ((func args-1) (when (is_list args-1))
    (match-lambda
      ((args-2) (when (is_list args-2))
        (apply func (++ args-1 args-2)))
      ((arg-2)
        (apply func (++ args-1 `(,arg-2))))))
  ((func arg-1)
    (match-lambda
      ((args-2) (when (is_list args-2))
        (apply func (++ `(,arg-1) args-2)))
      ((arg-2)
        (funcall func arg-1 arg-2)))))
