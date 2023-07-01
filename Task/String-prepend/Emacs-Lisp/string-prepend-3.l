(let ((buf (get-buffer-create "*foo*")))
  (with-current-buffer buf
    (insert "bar"))
  (with-current-buffer buf
    (goto-char (point-min))
    (insert "foo")
    (buffer-string)))
;; => "foobar"
