(defparameter *fibo-start* '(1 1)) ; elements 1 and 2

;;; Helper functions
(defun grow-fibo (fibo)
    (cons (+ (first fibo) (second fibo)) fibo))

(defun generate-fibo (fibo n) ; n must be > 1
    (if (equal (list-length fibo) n)
        fibo
        (generate-fibo (grow-fibo fibo)  n)))

;;; User functions
(defun fibo (n)
    (cond ((= n 0) 0)
          ((= (abs n) 1) 1)
          (t (let ((result (first (generate-fibo *fibo-start* (abs n)))))
               (if (and (< n -1) (evenp n))
                 (- result)
                 result)))))

(defun fibo-list (n)
    (cond ((< n 1) nil)
          ((= n 1) '(1))
          (t (reverse (generate-fibo *fibo-start* n)))))

(defun fibo-range (lower upper)
   (if (<= upper lower)
     nil
     (reverse (generate-fibo
                 (list
                    (fibo (1+ lower))
                    (fibo  lower))
                 (1+ (- upper lower))))))
