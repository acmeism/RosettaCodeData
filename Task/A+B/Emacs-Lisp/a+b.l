;; Write this code in a file: a+b.el
;; Put input.txt in the same directory than a+b.el
;; Open a+b.el in emacs and run the program with: M-x eval-buffer
(defun solve (xs) (mapcar (lambda (ys) (apply '+ ys)) xs))

(with-temp-buffer
  (insert-file-contents "input.txt")
  (setq content (split-string (buffer-string) "\n" t))
  (setq xs (mapcar (lambda (zs) (mapcar #'string-to-number (split-string zs))) content))
  (delete-other-windows)
  (find-file-other-window "output.txt")
  (erase-buffer)
  (insert (mapconcat (lambda (x) (format "%d" x)) (solve xs) "\n"))
  (save-buffer))
