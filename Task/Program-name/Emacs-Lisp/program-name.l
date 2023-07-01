:;exec emacs -batch -l $0 -f main $*

;;; Shebang from John Swaby
;;; http://www.emacswiki.org/emacs/EmacsScripts

(defun main ()
  (let ((program (nth 2 command-line-args)))
    (message "Program: %s" program)))
