(define-application-frame simple-windowed-application ()
  ((clicks :initform 0
           :accessor clicks-of))
  (:panes
   (the-label :application
              :width '(40 :character)
              :height '(3 :character)
              :display-time t
              :display-function
                (lambda (pane stream)
                  (declare (ignore pane))
                  (format stream "~[There have been no clicks yet.~
                                    ~:;~:*There ~[have~;has~:;have~]~:* been ~R click~:P.~]"
                          (clicks-of *application-frame*))))
   (the-button :push-button
               :label "Click Me"
               :activate-callback
                 (lambda (button)
                   (declare (ignore button))
                   (incf (clicks-of *application-frame*))
                   (redisplay-frame-pane *application-frame*
                                         (find-pane-named *application-frame* 'the-label)
                                         :force-p t))))
  (:layouts (default
             (vertically (:equalize-width nil :align-x :center)
               the-label
               (spacing (:thickness 10) the-button)))))
