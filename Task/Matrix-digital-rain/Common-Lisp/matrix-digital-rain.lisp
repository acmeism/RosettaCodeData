(defun matrix-digital-rain ()
  (with-screen (scr :input-echoing nil :input-blocking nil :cursor-visible nil)
    (let* ((width (width scr))
           (height (height scr))
           ;; start at a random height in each column.
           (positions (loop repeat width collect (random height)))
           ;; run each column at a random speed.
           (speeds (loop repeat width collect (random 4))))
      ;; generate a random ascii char
      (flet ((randch () (+ 64 (random 58))))
        ;; hit the q key to exit the main loop.
        (bind scr #\q 'exit-event-loop)
        (bind scr nil
          (lambda (win event)
            (loop for col from 0 to (1- width) do
              (loop repeat (nth col speeds) do
                ;; position of the first point in the current column
                (let ((pos (nth col positions)))
                  (setf (attributes win) '(:bold))
                  (setf (fgcolor win) :green)
                  (add win (randch) :y (mod pos height) :x col :fgcolor :white)
                  (add win (randch) :y (mod (- pos 1) height) :x col)
                  (add win (randch) :y (mod (- pos 2) height) :x col)
                  (setf (attributes win) '())
                  (add win (randch) :y (mod (- pos 3) height) :x col)
                  ;; overwrite the last char half the height from the first char.
                  (add win #\space  :y (mod (- pos (floor height 2)) height) :x col)
                  (refresh win)
                  ;; advance the current column
                  (setf (nth col positions) (mod (+ pos 1) height))))))))
      (setf (frame-rate scr) 20)
      (run-event-loop scr))))
