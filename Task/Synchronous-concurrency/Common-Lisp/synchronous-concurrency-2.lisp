(defun reader (pathname writer)
  (with-open-file (stream pathname)
    (loop for line = (read-line stream nil)
          while line
          do (message writer '|here's a line for you| line)
          finally
       (message writer '|how many lines?|)
       (receive-one-message (|line count| count)
          (format t "line count: ~D~%" count))
       (message writer '|looks like i've got no more lines|))))

(defun writer (stream reader)
  ;; that would work better with ITERATE
  (loop with line-count = 0 do
    (receive-message
     ((|here's a line for you| line)
      (write-line line stream)
      (incf line-count))
     (|looks like i've got no more lines|
      (return))
     (|how many lines?|
      (message reader '|line count| line-count)))))

(defmacro thread (queue &body body)
  `(make-thread (lambda (&aux (*self* ,queue))
                  ,@body)))

(defun synchronous-concurrency (&key (pathname "input.txt"))
  (let ((reader (queue))
        (writer (queue)))
    (thread reader (reader pathname writer))
    (thread writer (writer *standard-output* reader)))
  (values))
