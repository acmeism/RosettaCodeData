;; Using the LTK library...

(defun gui-test ()
  "the main window for the input test"
  (ltk:with-ltk ()
    (ltk:wm-title ltk:*tk* "GUI Test")
    (ltk:bind ltk:*tk* "<Alt-q>" (lambda (evt)
				   (declare (ignore evt))
				   (setf ltk:*exit-mainloop* t)))
    (let* (;; Initializing random generator
	   (*random-state* (make-random-state t))
	   ;; Creating widgets
	   (the-input (make-instance 'ltk:entry
				     :text "0"
				     :validate :key))
	   (f (make-instance 'ltk:frame))
	   (btn1 (make-instance 'ltk:button :text "random" :master f))
	   (btn2 (make-instance 'ltk:button :text "increment" :master f)))
      ;; Associating actions with widgets
      (ltk:bind btn1 "<Button-1>"
		(lambda (evt)
		  (declare (ignore evt))
		  (when (ltk:ask-yesno "Really reset to random?" :title "Question")
		    (setf (ltk:text the-input) (write-to-string (random 10000))))))
      (ltk:bind btn2 "<Button-1>"
		(lambda (evt)
		  (declare (ignore evt))
		  (setf (ltk:text the-input)
			(write-to-string (1+ (parse-integer (ltk:text the-input)))))))
      (ltk:format-wish "~A configure -validatecommand {string is int %P}"
		       (ltk:widget-path the-input))
      (ltk:focus the-input)
      ;; Placing widgets on the window
      (ltk:pack the-input :side :top)
      (ltk:pack f :side :bottom)
      (ltk:pack btn1 :side :left)
      (ltk:pack btn2 :side :right))))

(gui-test)
