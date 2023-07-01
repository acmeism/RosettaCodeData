(defun chess960-from-sp-id
  (&optional (sp-id (random 360 (make-random-state t))))
    (labels
      ((combinations (lst r)
          (cond
            ((numberp lst)
              (combinations (loop for i from 0 while (< i lst) collect i) r))
            ((= r 1)
              (mapcar #'list lst))
            (t
              (loop for i in lst append
                (let ((left (loop for j in lst if (< i j) collect j)))
                  (mapcar (lambda (c) (cons i c))
                          (combinations left (1- r))))))))

       (enumerate (ary)
          (loop for item across ary for index from 0
                collect (list index item))))

       (let*
         ((first-bishop -1)
          (knight-combo '())
          (placements (list
            ;divisor  function to get position                              piece symbol
            (list  4  (lambda (n) (setq first-bishop n)
                                  (1+ (* 2 n)))                             '♝)
            (list  4  (lambda (n) ( - (* 2 n) (if (> n first-bishop) 1 0))) '♝)
            (list  6  #'identity                                            '♛)
            (list 10  (lambda (n)
                        (setq knight-combo (nth n (combinations 5 2)))
                        (car knight-combo))                                 '♞)
            (list  1  (lambda (n) (1- (cadr knight-combo)))                 '♞)
            (list  1  (lambda (n) 0)                                        '♜)
            (list  1  (lambda (n) 0)                                        '♚)
            (list  1  (lambda (n) 0)                                        '♜)))
          (p sp-id)
          (ary (make-array 8 :initial-element '-)))

         (loop for (divisor func piece) in placements doing
           (let* ((n (mod p divisor))
             (square (funcall func n)))
              (setq p (floor p divisor))
              (setq index
                (car (nth square (remove-if-not (lambda (p) (eq (cadr p) '-))
                                                (enumerate ary)))))
              (setf (aref ary index) piece)))

      (list sp-id ary))))

;; demo

(format t "~a~%" (chess960-from-sp-id 518))
(format t "~a~%" (chess960-from-sp-id))
