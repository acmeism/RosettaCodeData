(let ((string "top and tail"))
  (substring string 1) ;=> "op and tail"
  (substring string 0 (1- (length string))) ;=> "top and tai"
  (substring string 1 (1- (length string)))) ;=> "op and tai"
