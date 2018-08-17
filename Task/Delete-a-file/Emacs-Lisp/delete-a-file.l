;; function to remove file & directory
(defun my-files-rm ()
  (delete-file "input.txt")
  (delete-directory "docs"))

(my-files-rm)
(cd "~/") ;; change to home dir
(my-files-rm)
