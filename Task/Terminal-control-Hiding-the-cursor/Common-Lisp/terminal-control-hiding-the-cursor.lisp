(defun sh (cmd)
  #+clisp (shell cmd)
  #+ecl (si:system cmd)
  #+sbcl (sb-ext:run-program "/bin/sh" (list "-c" cmd) :input nil :output *standard-output*)
  #+clozure (ccl:run-program "/bin/sh" (list "-c" cmd) :input nil :output *standard-output*))

(defun show-cursor (x)
  (if x (sh "tput cvvis") (sh "tput civis")))

(show-cursor nil)
(sleep 3)
(show-cursor t)
(sleep 3)
