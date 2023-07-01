(defun bernouilli (n)
  (loop with a = (make-array (list (1+ n)))
     for m from 0 to n do
       (setf (aref a m) (/ 1 (+ m 1)))
       (loop for j from m downto 1 do
            (setf (aref a (- j 1))
                  (* j (- (aref a j) (aref a (- j 1))))))
     finally (return (aref a 0))))

;;Print outputs to stdout:

(loop for n from 0 to 60 do
     (let ((b (bernouilli n)))
       (when (not (zerop b))
         (format t "~a: ~a~%" n b))))


;;For the "extra credit" challenge, we need to align the slashes.

(let (results)
  ;;collect the results
  (loop for n from 0 to 60 do
       (let ((b (bernouilli n)))
         (when (not (zerop b)) (push (cons b n) results))))
  ;;parse the numerators into strings; save the greatest length in max-length
  (let ((max-length (apply #'max (mapcar (lambda (r)
                                           (length (format nil "~a" (numerator r))))
                                         (mapcar #'car results)))))
    ;;Print the numbers with using the fixed-width formatter: ~Nd, where N is
    ;;the number of leading spaces. We can't just pass in the width variable
    ;;but we can splice together a formatting string that includes it.

    ;;We also can't use the fixed-width formatter on a ratio, so we have to split
    ;;the ratio and splice it back together like idiots.
    (loop for n in (mapcar #'cdr (reverse results))
          for r in (mapcar #'car (reverse results)) do
         (format t (concatenate 'string
                                "B(~2d): ~"
                                (format nil "~a" max-length)
                                "d/~a~%")
                 n
                 (numerator r)
                 (denominator r)))))
