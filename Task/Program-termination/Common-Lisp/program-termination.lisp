(defun terminate (status)
  #+sbcl     (           sb-ext:quit      :unix-status status)    ; SBCL
  #+ccl      (              ccl:quit      status)                 ; Clozure CL
  #+clisp    (              ext:quit      status)                 ; GNU CLISP
  #+cmu      (             unix:unix-exit status)                 ; CMUCL
  #+ecl      (              ext:quit      status)                 ; ECL
  #+abcl     (              ext:quit      :status status)         ; Armed Bear CL
  #+allegro  (             excl:exit      status :quiet t)        ; Allegro CL
  #+gcl      (common-lisp-user::bye       status)                 ; GCL
  #+ecl      (              ext:quit      status)                 ; ECL
  (cl-user::quit))           ; Many implementations put QUIT in the sandbox CL-USER package.
