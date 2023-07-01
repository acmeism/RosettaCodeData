(defmacro mean args
  `(/ (lists:sum ,args)
      ,(length args)))
