(defun test-mid3 ()
  (let ((test-lst (list 123
                        12345
                        1234567
                        987654321
                        10001
                        -10001
                        -123
                        -100
                        100
                        -12345
                        1
                        2
                        -1
                        -10
                        2002
                        -2002
                        0
                        )))
    (labels
        ((run-tests (lst)
           (cond ((null lst)
                  nil)

                 (t
                  (format t "~A ~15T ~A~%" (first lst) (mid3 (first lst)))
                  (run-tests (rest lst))))))

      (run-tests test-lst)))
  (values)
  )
