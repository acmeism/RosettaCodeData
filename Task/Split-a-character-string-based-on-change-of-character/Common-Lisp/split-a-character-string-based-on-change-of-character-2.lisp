(defun split (string)
  (flet ((make-buffer ()
           (make-array 0 :element-type 'character :adjustable t :fill-pointer t)))
    (loop with buffer = (make-buffer)
          with result
          for prev = nil then c
          for c across string
          when (and prev (char/= c prev))
            do (push buffer result)
               (setf buffer (make-buffer))
          do (vector-push-extend c buffer)
          finally (push buffer result)
                  (format t "~{~A~^, ~}"(nreverse result)))))

(split "gHHH5YY++///\\")
