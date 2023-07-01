(defun test-utf-8 ()
  "Return t if the chosen unicode points are encoded and decoded correctly."
  (let* ((unicodes-orig (list 65 246 1046 8364 119070))
         (unicodes-test (mapcar #'(lambda (x) (utf-8-to-unicode (unicode-to-utf-8 x)))
                                unicodes-orig)))
    (mapcar #'(lambda (x)
                (format t
                        "character ~A, code point: ~6x, utf-8: ~{~x ~}~%"
                        (code-char x)
                        x
                        (unicode-to-utf-8 x)))
            unicodes-orig)
    ;; return t if all are t
    (every #'= unicodes-orig unicodes-test)))
