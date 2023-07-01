(defun stern-brocot (numbers)
  (declare ((or null (vector integer)) numbers))
  (cond ((null numbers)
         (setf numbers (make-array 2 :element-type 'integer :adjustable t :fill-pointer t
                                     :initial-element 1)))
        ((zerop (length numbers))
         (vector-push-extend 1 numbers)
         (vector-push-extend 1 numbers))
        (t
         (assert (evenp (length numbers)))
         (let* ((considered-index (/ (length numbers) 2))
                (considered (aref numbers considered-index))
                (precedent  (aref numbers (1- considered-index))))
           (vector-push-extend (+ considered precedent) numbers)
           (vector-push-extend considered numbers))))
  numbers)

(defun first-15 ()
  (loop for input = nil then seq
        for seq = (stern-brocot input)
        while (< (length seq) 15)
        finally (format t "First 15: ~{~A~^ ~}~%" (coerce (subseq seq 0 15) 'list))))

(defun first-1-to-10 ()
  (loop with seq = (stern-brocot nil)
        for i from 1 to 10
        for index = (loop with start = 0
                          for pos = (position i seq :start start)
                          until pos
                          do (setf start (length seq)
                                   seq   (stern-brocot seq))
                          finally (return (1+ pos)))
        do (format t "First ~D at ~D~%" i index)))

(defun first-100 ()
  (loop for input = nil then seq
        for start = (length input)
        for seq = (stern-brocot input)
        for pos = (position 100 seq :start start)
        until pos
        finally (format t "First 100 at ~D~%" (1+ pos))))

(defun check-gcd ()
  (loop for input = nil then seq
        for seq = (stern-brocot input)
        while (< (length seq) 1000)
        finally (if (loop for i from 0 below 999
                          always (= 1 (gcd (aref seq i) (aref seq (1+ i)))))
                    (write-line "Correct.  The GCDs of all the two consecutive numbers are 1.")
                    (write-line "Wrong."))))

(defun main ()
  (first-15)
  (first-1-to-10)
  (first-100)
  (check-gcd))
