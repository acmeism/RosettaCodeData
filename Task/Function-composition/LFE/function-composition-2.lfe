> (funcall (compose #'math:sin/1 #'math:asin/1)
           0.5)
0.49999999999999994
> (funcall (compose `(,#'math:sin/1
                      ,#'math:asin/1
                      ,(lambda (x) (+ x 1))))
           0.5)
1.5
> (check)
Expected answer: 0.49999999999999994
Answer with compose: 0.49999999999999994
ok
>
