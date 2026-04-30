(let ((buf (get-buffer-create "*foo*")))
  (with-current-buffer buf
    (insert "foo"))
  (with-current-buffer buf
    (goto-char (point-max))
    (insert "bar")
    (buffer-string)))
;; => "foobar"
