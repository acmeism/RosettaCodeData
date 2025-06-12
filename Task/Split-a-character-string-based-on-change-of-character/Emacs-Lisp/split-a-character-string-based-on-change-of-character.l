(defun get-char-values ()
  "List ascii values of chars in buffer named test-string."
  (let ((my-chars)
        (current-point 1))
    (with-current-buffer "test-string"
      (while (char-after current-point)
        (push (char-after current-point) my-chars)
        (setq current-point (1+ current-point)))
    (nreverse my-chars))))

    (defun show-chars (ascii-values)
  "Show characters from VALUES."
  (let* ((first-char (nth 0 ascii-values))
         (current-char)
         (current-position 1)
         (first-element t)
         (separator ", "))
    (when first-element
      (setq first-element nil)
      (setq previous-char first-char)
      (insert first-char))
    (while (< current-position (length ascii-values))
      (setq current-char (nth current-position ascii-values))
      (if (equal current-char previous-char)
          (insert current-char)
          (insert separator)
        (insert current-char))
      (setq previous-char current-char)
      (setq current-position (1+ current-position)))))
