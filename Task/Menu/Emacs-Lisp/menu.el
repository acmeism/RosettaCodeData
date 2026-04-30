(let ((prompt-buffer-name "***** prompt *****")
      (option-list '("fee fie"
		     "huff and puff"
		     "mirror mirror"
		     "tick tock"))
      (extra-prompt-message "")
      (is-selected nil)
      (user-input-value nil))

  ;; Switch to an empty buffer
  (switch-to-buffer-other-window prompt-buffer-name)
  (read-only-mode -1)
  (erase-buffer)
  ;; Display the options
  (cl-loop for opt-idx from 1 to (length option-list) do
	   (insert (format "%d\) %s \n" opt-idx (nth (1- opt-idx) option-list))))

  (while (not is-selected)
    ;; Read user input
    (setq user-input-value (read-string (concat "select an option" extra-prompt-message " : ")))
    (setq user-input-value (read user-input-value))
    ;; Validate user input
    (if (and (fixnump user-input-value)
	       (<= user-input-value (length option-list))
	       (> user-input-value 0))
	;; Display result
	(progn
	  (end-of-buffer)
	  (insert (concat "\nYou selected: " (nth (1- user-input-value) option-list)))
	  (setq is-selected 't)
	  )
      (progn
	(setq extra-prompt-message " (please input a valid number)")
	)
      )
    )
  )
