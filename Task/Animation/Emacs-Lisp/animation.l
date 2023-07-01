(defun animation-start ()
  (interactive)
  (make-thread
   (lambda ()
     (let ()
       (setq **animation-state** (make-hash-table))
       (puthash 'offset 0 **animation-state**)
       (puthash 'sleep-cnt 5 **animation-state**)
       (puthash 'len 20 **animation-state**)
       (puthash 'buffer (make-string (gethash 'len **animation-state**) ? )
		**animation-state**)
       (puthash 'text "Hello World!" **animation-state**)
       (puthash 'forward 't **animation-state**)

       (switch-to-buffer-other-window "**animation**")
       (erase-buffer)
       (insert "\n")
       (insert-button
	"Revert Direction"
	'action (lambda (x)
		  (let ((forward (gethash 'forward **animation-state**)))
		    (puthash 'forward (not forward) **animation-state**)))
	'follow-link 't)

       (while 't
	 (let ((offset (gethash 'offset **animation-state**))
	       (len (gethash 'len **animation-state**))
	       (txt (gethash 'text **animation-state**))
	       (buff (gethash 'buffer **animation-state**))
	       (is-forward (gethash 'forward **animation-state**)))
	
	   (fillarray buff ? )
	   (seq-map-indexed (lambda (ch idx)
			      (aset buff (% (+ offset idx) len) ch))
			    txt)
	   (puthash 'buffer buff **animation-state**)
	   (if is-forward
	       (puthash 'offset (1+ offset) **animation-state**)
	     (puthash 'offset (% (+ len (1- offset)) len) **animation-state**))
	
	   ;;(erase-buffer)
	   (beginning-of-buffer)
	   (delete-region (line-beginning-position) (line-end-position))
	   (insert buff)
	   ;;(message buff)
	   )
	 (sleep-for 0 500)
	 )
       )
     )
   "animation thread")
  )

(animation-start)
