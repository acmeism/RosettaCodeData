(defun fft (a &key (inverse nil) &aux (n (length a)))
  "Perform the FFT recursively on input vector A.
   Vector A must have length N of power of 2."
  (declare (type boolean inverse)
           (type (integer 1) n))
  (if (= n 1)
      a
      (let* ((n/2 (/ n 2))
             (2iπ/n (complex 0 (/ (* 2 pi) n (if inverse -1 1))))
             (⍵_n (exp 2iπ/n))
             (⍵ #c(1.0d0 0.0d0))
             (a0 (make-array n/2))
             (a1 (make-array n/2)))
        (declare (type (integer 1) n/2)
                 (type (complex double-float) ⍵ ⍵_n))
        (symbol-macrolet ((a0[j]  (svref a0 j))
                          (a1[j]  (svref a1 j))
                          (a[i]   (svref a i))
                          (a[i+1] (svref a (1+ i))))
          (loop :for i :below (1- n) :by 2
                :for j :from 0
                :do (setf a0[j] a[i]
                          a1[j] a[i+1])))
        (let ((â0 (fft a0 :inverse inverse))
              (â1 (fft a1 :inverse inverse))
              (â (make-array n)))
          (symbol-macrolet ((â[k]     (svref â k))
                            (â[k+n/2] (svref â (+ k n/2)))
                            (â0[k]    (svref â0 k))
                            (â1[k]    (svref â1 k)))
            (loop :for k :below n/2
                  :do (setf â[k]     (+ â0[k] (* ⍵ â1[k]))
                            â[k+n/2] (- â0[k] (* ⍵ â1[k])))
                  :when inverse
                    :do (setf â[k]     (/ â[k] 2)
                              â[k+n/2] (/ â[k+n/2] 2))
                  :do (setq ⍵ (* ⍵ ⍵_n))
                  :finally (return â)))))))
