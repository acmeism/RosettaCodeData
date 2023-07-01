(defun turing (initial terminal blank rules tape &optional (verbose NIL))
  (labels ((run (state front back)
             (if (equal state terminal)
               (progn
                 (when verbose
                   (show-tape front back))
                 (combine front back))
               (let ((current-content (or (car back) blank)))
                 (destructuring-bind
                   (new-state new-content move)
                   (gethash (cons state current-content) rules)
                   (when verbose
                     (show-tape front back))
                   (cond ((eq move 'right)
                          (run new-state
                               (cons new-content front)
                               (cdr back)))
                         ((eq move 'left)
                          (run new-state
                               (cdr front)
                               (list* (car front) new-content (cdr back))))
                         (T (run new-state
                                 front
                                 (cons new-content (cdr back)))))))))

            (show-tape (front back)
              (format T "~{~a~}[~a]~{~a~}~%"
                      (nreverse (subseq front 0 (min 10 (length front))))
                      (or (car back) blank)
                      (subseq (cdr back) 0 (min 10 (length (cdr back))))))

            (combine (front back)
             (if front
               (combine (cdr front) (cons (car front) back))
               back)))

    (run initial '() tape)))
