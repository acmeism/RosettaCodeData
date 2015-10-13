(ql:quickload '(cl-openal cl-alc))

(defparameter *short-max* (- (expt 2 15) 1))
(defparameter *2-pi* (* 2 pi))

(defun make-sin (period)
  "Create a generator for a sine wave of the given PERIOD."
  (lambda (x)
    (sin (* *2-pi* (/ x period)))))

(defun make-tone (length frequency sampling-frequency)
  "Create a vector containing sound information of the given LENGTH,
FREQUENCY, and SAMPLING-FREQUENCY."
  (let ((data (make-array (truncate (* length sampling-frequency))
                          :element-type '(signed-byte 16)))
        (generator (make-sin (/ sampling-frequency frequency))))
    (dotimes (i (length data))
      (setf (aref data i)
            (truncate (* *short-max* (funcall generator i)))))
    data))

(defun internal-time-ms ()
  "Get the process's real time in ms."
  (* 1000 (/ (get-internal-real-time) internal-time-units-per-second)))

(defun spin-wait (next-real-time)
  "Wait until the process's real time has reached the given time."
  (loop while (< (internal-time-ms) next-real-time)))

(defun upload (buffer data sampling-frequency)
  "Upload the given vector DATA to a BUFFER at the given SAMPLING-FREQUENCY."
  (cffi:with-pointer-to-vector-data (data-ptr data)
    (al:buffer-data buffer :mono16 data-ptr (* 2 (length data))
                    sampling-frequency)))

(defun metronome (beats/minute pattern &optional (sampling-frequency 44100))
  "Play a metronome until interrupted."
  (let ((ms/beat (/ 60000 beats/minute)))
    (alc:with-device (device)
      (alc:with-context (context device)
        (alc:make-context-current context)
        (al:with-buffer (low-buffer)
          (al:with-buffer (high-buffer)
            (al:with-source (source)
              (al:source source :gain 0.5)
              (flet ((play-it (buffer)
                       (al:source source :buffer buffer)
                       (al:source-play source))
                     (upload-it (buffer time frequency)
                       (upload buffer
                               (make-tone time frequency sampling-frequency)
                               sampling-frequency)))
                (upload-it low-buffer 0.1 440)
                (upload-it high-buffer 0.15 880)
                (let ((next-scheduled-tone (internal-time-ms)))
                  (loop
                     (loop for symbol in pattern do
                          (spin-wait next-scheduled-tone)
                          (incf next-scheduled-tone ms/beat)
                          (case symbol
                            (l (play-it low-buffer))
                            (h (play-it high-buffer)))
                          (princ symbol))
                     (terpri)))))))))))
