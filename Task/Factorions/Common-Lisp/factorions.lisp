(defparameter *bases* '(9 10 11 12))
(defparameter *limit* 1500000)

(defun ! (n) (apply #'* (loop for i from 2 to n collect i)))

(defparameter *digit-factorials* (mapcar #'! (loop for i from 0 to (1- (apply #'max *bases*)) collect i)))

(defun fact (n) (nth n *digit-factorials*))

(defun digit-value (digit)
  (let ((decimal (digit-char-p digit)))
    (cond ((not (null decimal)) decimal)
          ((char>= #\Z digit #\A) (+ (char-code digit) (- (char-code #\A)) 10))
          ((char>= #\z digit #\a) (+ (char-code digit) (- (char-code #\a)) 10))
          (t nil))))

(defun factorionp (n &optional (base 10))
  (= n (apply #'+
            (mapcar #'fact
                    (map 'list #'digit-value
                         (write-to-string n :base base))))))

(loop for base in *bases* do
  (let ((factorions
        (loop for i from 1 while (< i *limit*) if (factorionp i base) collect i)))
    (format t "In base ~a there are ~a factorions:~%" base (list-length factorions))
    (loop for n in factorions do
      (format t "~c~a" #\Tab (write-to-string n :base base))
      (if (/= base 10) (format t " (decimal ~a)" n))
      (format t "~%"))
    (format t "~%")))
