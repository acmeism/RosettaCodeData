(defvar *probabilities* '((aleph  1/5)
                          (beth   1/6)
                          (gimel  1/7)
                          (daleth 1/8)
                          (he     1/9)
                          (waw    1/10)
                          (zayin  1/11)
                          (heth   1759/27720)))
(defun calculate-probabilities (choices &key (repetitions 1000000))
  (assert (= 1 (reduce #'+ choices :key #'second)))
  (labels ((make-ranges ()
             (loop for (datum probability) in choices
                   sum (coerce probability 'double-float) into total
                   collect (list datum total)))
           (pick (ranges)
             (declare (optimize (speed 3) (safety 0) (debug 0)))
             (loop with random = (random 1.0d0)
                   for (datum below) of-type (t double-float) in ranges
                   when (< random below)
                     do (return datum)))
           (populate-hash (ranges)
             (declare (optimize (speed 3) (safety 0) (debug 0)))
             (loop repeat (the fixnum repetitions)
                   with hash = (make-hash-table)
                   do (incf (the fixnum (gethash (pick ranges) hash 0)))
                   finally (return hash)))
           (make-table-data (hash)
             (loop for (datum probability) in choices
                   collect (list datum
                                 (float (/ (gethash datum hash)
                                           repetitions))
                                 (float probability)))))
    (format t "Datum~10,2TOccured~20,2TExpected~%")
    (format t "~{~{~A~10,2T~F~20,2T~F~}~%~}"
                 (make-table-data (populate-hash (make-ranges))))))

CL-USER> (calculate-probabilities *probabilities*)
Datum     Occured   Expected
ALEPH     0.200156  0.2
BETH      0.166521  0.16666667
GIMEL     0.142936  0.14285715
DALETH    0.124779  0.125
HE        0.111601  0.11111111
WAW       0.100068  0.1
ZAYIN     0.090458  0.09090909
HETH      0.063481  0.06345599
