(rot13-string "abc") ;=> "nop"
(with-temp-buffer
  (insert "abc")
  (rot13-region (point-min) (point-max))
  (buffer-string)) ;=> "nop"
