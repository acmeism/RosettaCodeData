:;exec emacs -batch -l $0 -f main $*

;;; Shebang from John Swaby
;;; http://www.emacswiki.org/emacs/EmacsScripts

(defun main ()
 (setq load-path (cons default-directory load-path))
 (load "scriptedmain.el" nil t)
 (message "Test: The meaning of life is %d" (meaning-of-life)))
