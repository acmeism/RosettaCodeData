(define-application-frame simple-windowed-application ()
  ((clicks :initform 0
           :accessor clicks-of))
  (:menu-bar t)
  (:pane
   (make-pane 'application-pane
              :width '(40 :character)
              :height '(3 :character)
              :display-time :command-loop
              :display-function
                (lambda (pane stream)
                  (declare (ignore pane))
                  (format stream "~[There have been no clicks yet.~
                                    ~:;~:*There ~[have~;has~:;have~]~:* been ~R click~:P.~]"
                          (clicks-of *application-frame*))))))

(define-simple-windowed-application-command (com-click-me :menu t)
  ()
  (incf (clicks-of *application-frame*)))
