(defclass integrator ()
  ((input :initarg :input :writer input :reader %input)
   (lock :initform (bt:make-lock) :reader lock)
   (start-time :initform (get-internal-real-time) :reader start-time)
   (interval :initarg :interval :reader interval)
   (thread :reader thread :writer %set-thread)
   (area :reader area :initform 0 :accessor %area)))

(defmethod shared-initialize
    ((integrator integrator) slot-names &key (interval nil interval-s-p) &allow-other-keys)
  (declare (ignore interval))
  (cond
    ;; Restart the thread if any unsynchronized slots are
    ;; being initialized
    ((or
      (eql slot-names t)
      (member 'thread slot-names)
      (member 'interval slot-names)
      (member 'start-time slot-names)
      (member 'lock slot-names)
      interval-s-p)
     ;; If the instance already has a thread, stop it and wait for it
     ;; to stop before initializing any slots
     (when (slot-boundp integrator 'thread)
       (input nil integrator)
       (bt:join-thread (thread integrator)))
     (call-next-method)
     (let* ((now (get-internal-real-time))
            (current-value (funcall (%input integrator) (- (start-time integrator) now))))
       (%set-thread
        (bt:make-thread
         (lambda ()
           (loop
             ;; Sleep for the amount required to reach the next interval;
             ;; mitigates drift from theoretical interval times
             (sleep
              (mod
               (/ (- (start-time integrator) (get-internal-real-time))
                  internal-time-units-per-second)
               (interval integrator)))
             (let* ((input
                      (bt:with-lock-held ((lock integrator))
                        ;; If input is nil, exit the thread
                        (or (%input integrator) (return))))
                    (previous-time (shiftf now (get-internal-real-time)))
                    (previous-value
                      (shiftf
                       current-value
                       (funcall input (/ (- now (start-time integrator)) internal-time-units-per-second)))))
               (bt:with-lock-held ((lock integrator))
                 (incf (%area integrator)
                       (*
                        (/ (- now previous-time)
                           internal-time-units-per-second)
                        (/ (+ previous-value current-value)
                           2)))))))
         :name "integrator-thread")
        integrator)))
    (t
     ;; If lock is not in SLOT-NAMES, it must already be initialized,
     ;; so it can be taken while slots synchronized to it are set
     (bt:with-lock-held ((lock integrator))
       (call-next-method)))))

(defmethod input :around (new-value (integrator integrator))
  (bt:with-lock-held ((lock integrator))
    (call-next-method)))

(defmethod area :around ((integrator integrator))
  (bt:with-lock-held ((lock integrator))
    (call-next-method)))

(let ((integrator
        (make-instance 'integrator
                       :input (lambda (time) (sin (* 2 pi 0.5 time)))
                       :interval 1/1000)))
  (unwind-protect
       (progn
         (sleep 2)
         (input (constantly 0) integrator)
         (sleep 0.5)
         (format t "~F~%" (area integrator)))
    (input nil integrator)))
