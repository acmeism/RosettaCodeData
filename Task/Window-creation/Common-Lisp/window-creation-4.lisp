(defun create-window ()
  "Creates a window"
  (let ((window (jnew (jconstructor "javax.swing.JFrame"))))
	(jcall (jmethod "javax.swing.JFrame" "setVisible" "boolean")
		   window (make-immediate-object t :boolean))))

(create-window)
