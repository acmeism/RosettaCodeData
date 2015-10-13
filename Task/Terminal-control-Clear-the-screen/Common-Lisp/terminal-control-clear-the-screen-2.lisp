(defun sh (cmd)
   "A multi-implementation function equivalent for the C function system"
   #+clisp (shell cmd)
   #+ecl (si:system cmd)
   #+sbcl (sb-ext:run-program "/bin/sh" (list "-c" cmd) :input nil :output *standard-output*)
   #+clozure (ccl:run-program "/bin/sh" (list "-c" cmd) :input nil :output *standard-output*))
(sh "clear")
