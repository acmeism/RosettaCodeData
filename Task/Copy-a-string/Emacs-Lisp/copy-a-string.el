(let* ((str1 "hi")
       (str1-ref str1)
       (str2 (copy-sequence str1)))
  (eq str1 str1-ref) ;=> t
  (eq str1 str2) ;=> nil
  (equal str1 str1-ref) ;=> t
  (equal str1 str2)) ;=> t
