;;; This is adapted from the Python sample; it uses lists for simplicity.
;;; Production code would use complex arrays (for compiler optimization).
;;; This version exhibits LOOP features, closing with compositional golf.
(defun fft (x &aux (length (length x)))
  ;; base case: return the list as-is
  (if (<= length 1) x
    ;; collect alternating elements into separate lists...
    (loop for (a b) on x by #'cddr collect a into as collect b into bs finally
          ;; ... and take the FFT of both;
          (let* ((ffta (fft as)) (fftb (fft bs))
                 ;; incrementally phase shift each element of the 2nd list
                 (aux (loop for b in fftb and k from 0 by (/ pi length -1/2)
                            collect (* b (cis k)))))
            ;; finally, concatenate the sum and difference of the lists
            (return (mapcan #'mapcar '(+ -) `(,ffta ,ffta) `(,aux ,aux)))))))
