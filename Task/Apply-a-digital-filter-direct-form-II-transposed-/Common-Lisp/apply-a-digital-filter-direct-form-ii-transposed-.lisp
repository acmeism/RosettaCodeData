(defparameter a #(1.00000000L0 -2.77555756L-16 3.33333333L-01 -1.85037171L-17))
(defparameter b #(0.16666667L0 0.50000000L0 0.50000000L0 0.16666667L0))
(defparameter s #(-0.917843918645 0.141984778794  1.20536903482   0.190286794412 -0.662370894973
                  -1.00700480494 -0.404707073677  0.800482325044  0.743500089861  1.01090520172
                   0.741527555207 0.277841675195  0.400833448236 -0.2085993586   -0.172842103641
                  -0.134316096293 0.0259303398477 0.490105989562  0.549391221511  0.9047198589))

(loop with out = (make-array (length s) :initial-element 0.0D0)
  for i below (length s)
  do (setf (svref out i)
           (/ (- (loop for j below (length b)
                   when (>= i j) sum (* (svref b j) (svref s (- i j))))
                 (loop for j below (length a)
                   when (>= i j) sum (* (svref a j) (svref out (- i j)))))
              (svref a 0)))
  (format t "~%~16,8F" (svref out i)))
