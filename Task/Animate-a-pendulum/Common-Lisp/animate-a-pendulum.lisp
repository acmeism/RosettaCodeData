(defvar *frame-rate* 30)
(defvar *damping* 0.99 "Deceleration factor.")

(defun make-pendulum (length theta0 x)
  "Returns an anonymous function with enclosed state representing a pendulum."
  (let* ((theta (* (/ theta0 180) pi))
         (acceleration 0))
    (if (< length 40) (setf length 40)) ;;avoid a divide-by-zero
    (lambda ()
      ;;Draws the pendulum, updating its location and speed.
      (sdl:draw-line (sdl:point :x x :y 1)
                     (sdl:point :x (+ (* (sin theta) length) x)
                                :y (* (cos theta) length)))
      (sdl:draw-filled-circle (sdl:point :x (+ (* (sin theta) length) x)
                                         :y (* (cos theta) length))
                              20
                              :color sdl:*yellow*
                              :stroke-color sdl:*white*)
      ;;The magic constant approximates the speed we want for a given frame-rate.
      (incf acceleration (* (sin theta) (* *frame-rate* -0.001)))
      (incf theta acceleration)
      (setf acceleration (* acceleration *damping*)))))


(defun main (&optional (w 640) (h 480))
  (sdl:with-init ()
    (sdl:window w h :title-caption "Pendulums"
                :fps (make-instance 'sdl:fps-fixed))
    (setf (sdl:frame-rate) *frame-rate*)
    (let ((pendulums nil))
      (sdl:with-events ()
        (:quit-event () t)
        (:idle ()
               (sdl:clear-display sdl:*black*)
               (mapcar #'funcall pendulums) ;;Draw all the pendulums

               (sdl:update-display))
        (:key-down-event (:key key)
                         (cond ((sdl:key= key :sdl-key-escape)
                                (sdl:push-quit-event))
                               ((sdl:key= key :sdl-key-space)
                                (push (make-pendulum (random (- h 100))
                                                     (random 90)
                                                     (round w 2))
                                      pendulums))))))))
