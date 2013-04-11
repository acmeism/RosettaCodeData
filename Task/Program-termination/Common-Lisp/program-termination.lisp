(defun terminate (status)
  #+sbcl     (sb-ext:quit      :unix-status status)    ; SBCL
  #+ccl      (   ccl:quit      status)                 ; Clozure CL
  #+clisp    (   ext:quit      status)                 ; GNU CLISP
  #+cmu      (  unix:unix-exit status)                 ; CMUCL
  #+abcl     (   ext:quit      :status status)         ; Armed Bear CL
  #+allegro  (  excl:exit      status :quiet t)        ; Allegro CL
  (cl-user::quit))           ; Many implementations put QUIT in the sandbox CL-USER package.
