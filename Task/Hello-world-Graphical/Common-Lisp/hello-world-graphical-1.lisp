(use-package :ltk)

(defun show-message (text)
  "Show message in a label on a Tk window"
  (with-ltk ()
      (let* ((label (make-instance 'label :text text))
             (button (make-instance 'button :text "Done"
                                    :command (lambda ()
                                               (ltk::break-mainloop)
                                               (ltk::update)))))
              (pack label :side :top :expand t :fill :both)
              (pack button :side :right)
              (mainloop))))

(show-message "Goodbye World")
