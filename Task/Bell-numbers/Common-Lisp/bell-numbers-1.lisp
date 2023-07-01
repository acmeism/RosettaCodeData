;; The triangle is a list of arrays; each array is a
;; triangle's row; the last row is at the head of the list.
(defun grow-triangle (triangle)
    (if (null triangle)
      '(#(1))
       (let* ((last-array (car triangle))
              (last-length (length last-array))
              (new-array (make-array (1+ last-length)
                                     :element-type 'integer)))
          ;; copy over the last element of the last array
          (setf (aref new-array 0) (aref last-array (1- last-length)))
          ;; fill in the rest of the array
          (loop for i from 0
                ;; the last index of the new array is the length
                ;; of the last array, which is 1 unit shorter
                for j from 1 upto last-length
                for sum = (+ (aref last-array i) (aref new-array i))
                do (setf (aref new-array j) sum))
          ;; return the grown list
          (cons new-array triangle))))

(defun make-triangle (num)
    (if (<= num 1)
      (grow-triangle nil)
      (grow-triangle (make-triangle (1- num)))))

(defun bell (num)
    (cond ((< num 0) nil)
          ((= num 0) 1)
          (t (aref (first (make-triangle num)) (1- num)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Printing section
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defparameter *numbers-to-print*
    (append
      (loop for i upto 19 collect i)
      '(49 50)))

(defun array->list (array)
    (loop for i upto (1- (length array))
      collect (aref array i)))

(defun print-bell-number (index bell-number)
    (format t "B_~d (~:r Bell number) = ~:d~%"
        index (1+ index) bell-number))


(defun print-bell-triangle (triangle)
    (loop for row in (reverse triangle)
      do (format t "~{~d~^, ~}~%" (array->list row))))

;; Final invocation
(loop for n in *numbers-to-print* do
    (print-bell-number n (bell n)))

(princ #\newline)

(format t "The first 10 rows of Bell triangle:~%")
(print-bell-triangle (make-triangle 10))
