(define (doors-toggle door-state)
  (define (doors-toggle-helper door-state num-doors step counter)
    (cond ((> step num-doors) door-state)
          ((> counter (1- num-doors))
           (doors-toggle-helper door-state num-doors (1+ step) step))
          (else (vector-set! door-state
                             counter
                             (not (array-ref door-state counter)))
                (doors-toggle-helper door-state
                                     num-doors
                                     step
                                     (+ step counter)))))
  (let ((step 1)
        (num-doors (vector-length door-state)))
    (doors-toggle-helper door-state num-doors step (1- step))))

(doors-toggle (make-vector 100 #f)) ;; #t is an open door, #f a closed one
