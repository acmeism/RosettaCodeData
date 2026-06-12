:;exec emacs -batch -l $0 -f main $*

;;; Shebang from John Swaby
;;; http://www.emacswiki.org/emacs/EmacsScripts

(defun meaning-of-life () 42)

(defun main ()
 (message "Main: The meaning of life is %d" (meaning-of-life)))
