(defun compose (f g)
  (lambda (x)
    (funcall f
      (funcall g x))))

(defun compose (funcs)
  (lists:foldl #'compose/2
               (lambda (x) x)
               funcs))

(defun check ()
  (let* ((sin-asin (compose #'math:sin/1 #'math:asin/1))
         (expected (math:sin (math:asin 0.5)))
         (compose-result (funcall sin-asin 0.5)))
    (io:format '"Expected answer: ~p~n" (list expected))
    (io:format '"Answer with compose: ~p~n" (list compose-result))))
