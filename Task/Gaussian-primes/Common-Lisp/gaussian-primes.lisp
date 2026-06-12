(defun norm (c)
  (+ (expt (realpart c) 2) (expt (imagpart c) 2)))

(defun primep (n)
  (cond ((< n 2) nil)
        ((evenp n) (= n 2))
        (t (do* ((isqrt-n (1+ (isqrt n)))
                 (d 3 (+ d 2)))
               ((> d isqrt-n) t)
             (when (zerop (mod n d))
               (return nil))))))

(defun gaussian-prime-p (c)
  (flet ((check (x) (and (= (logand x 3) 3) (primep x))))
    (let ((re (abs (realpart c)))
          (im (abs (imagpart c))))
      (cond ((zerop re) (check im))
            ((zerop im) (check re))
            (t (primep (norm c)))))))

(defun gaussian-primes-within (max-norm)
  (loop with m = (isqrt max-norm)
        for x from (- m) to m
        append (loop for y from (- m) to m
                     for c = (complex x y)
                     when (and (< (norm c) max-norm) (gaussian-prime-p c))
                       collect c)))

(defun format-complex (c)
  (format nil "~[~:;~:*~d~]~[~2:*~[0~]~:;~2:*~[~d~:;~@d~]i~]" (realpart c) (imagpart c)))

(write-line "Gaussian primes within radius 10 from origin of complex plane:")

(format t "~@<~{~1,6<~a ~>~^~:_~}~:>~%"
        (mapcar #'format-complex
                (sort (gaussian-primes-within 100) #'< :key #'norm)))

(defun plot-in-svg-on-complex-plane-within (radius numbers)
  (let* ((size (* 10 radius))
         (size*2 (* 2 size)))
    (format t "<svg xmlns='http://www.w3.org/2000/svg' ~
                width='~a' height='~a'>~%" size*2 size*2)
    (write-line "<rect style='width: 100%; height: 100%; fill: black' />")
    (format t "<line x1='0' y1='~a' x2='~a' y2='~a' ~
                stroke='white' stroke-width='2' />" size size*2 size)
    (format t "<line x1='~a' y1='0' x2='~a' y2='~a' ~
                stroke='white' stroke-width='2' />" size size size*2)
    (dolist (c numbers)
      (format t "<circle cx='~a' cy='~a' r='4' fill='yellow' />~%"
              (+ size (* 8 (realpart c)))
              (+ size (* 8 (imagpart c)))))
    (write-line "</svg>")))

(with-open-file (*standard-output* "gaussian-primes-plot.svg"
                 :direction :output :if-exists :supersede)
  (plot-in-svg-on-complex-plane-within 50 (gaussian-primes-within (* 50 50))))
