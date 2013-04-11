(declaim (ftype (function (vector vector &optional fixnum fixnum) vector)
                vector-append))
(defun vector-append (old new &optional (start2 0) end2)
  (declare (optimize (speed 3) (safety 0) (debug 0)))
  (prog1 old
    (let* ((old-fill (fill-pointer old))
           (new-fill (+ old-fill (length new))))
      (when (> new-fill (array-dimension old 0))
        (adjust-array old (* 4 new-fill)))
      (setf (fill-pointer old) new-fill)
      (replace old new :start1 old-fill :start2 start2 :end2 end2))))

(declaim (ftype (function (vector t) vector) vector-append1))
(defun vector-append1 (old new)
  (prog1 old
    (let* ((old-fill (fill-pointer old))
           (new-fill (1+ old-fill)))
      (when (> new-fill (array-dimension old 0))
        (adjust-array old (* 4 new-fill)))
      (setf (fill-pointer old) new-fill)
      (setf (aref old old-fill) new))))

(declaim (ftype (function (&optional t) vector) make-empty-vector))
(defun make-empty-vector (&optional (element-type t))
  (make-array 0 :element-type element-type :fill-pointer 0 :adjustable t))


(declaim (ftype (function (t &optional t) vector) make-vector-with-elt))
(defun make-vector-with-elt (elt &optional (element-type t))
  (make-array 1 :element-type element-type
                :fill-pointer 1
                :adjustable t
                :initial-element elt))

(declaim (ftype (function (vector t) vector) vector-append1-new))
(defun vector-append1-new (old new)
  (vector-append1 (vector-append (make-empty-vector 'octet) old)
                  new))

(declaim (ftype (function (vector vector) vector) vector-append-new))
(defun vector-append-new (old new)
  (vector-append (vector-append (make-empty-vector 'octet) old)
                 new))

(deftype octet () '(unsigned-byte 8))

(declaim (ftype (function () hash-table) build-dictionary))
(defun build-dictionary ()
  (let ((dictionary (make-hash-table :test #'equalp)))
    (loop for i below 256
          do (let ((vec (make-vector-with-elt i 'octet)))
               (setf (gethash vec dictionary) vec)))
    dictionary))

(declaim (ftype (function ((vector octet)) (vector octet))
                lzw-compress-octets))
(defun lzw-compress-octets (octets)
  (declare (optimize (speed 3) (safety 0) (debug 0)))
  (loop with dictionary-size of-type fixnum = 256
        with w = (make-empty-vector 'octet)
        with result = (make-empty-vector 't)
        with dictionary = (build-dictionary)
        for c across octets
        for wc = (vector-append1-new w c)
        if (gethash wc dictionary) do (setq w wc)
        else do
          (vector-append result (gethash w dictionary))
          (setf (gethash wc dictionary)
                (make-vector-with-elt dictionary-size))
          (incf dictionary-size)
          (setq w (make-vector-with-elt c 'octet))
        finally (unless (zerop (length (the (vector octet) w)))
                  (vector-append result (gethash w dictionary)))
                (return result)))

(declaim (ftype (function (vector) (vector octet)) lzw-decompress))
(defun #1=lzw-decompress (octets)
  (declare (optimize (speed 3) (safety 0) (debug 0)))
  (when (zerop (length octets))
    (return-from #1# (make-empty-vector 'octet)))
  (loop with dictionary-size = 256
        with dictionary = (build-dictionary)
        with result = (make-vector-with-elt (aref octets 0) 'octet)
        with w = (copy-seq result)
        for i from 1 below (length octets)
        for k = (make-vector-with-elt (aref octets i) 't)
        for entry = (or (gethash k dictionary)
                        (if (equalp k dictionary-size)
                            (coerce (list w (aref w 0)) '(vector octet))
                            (error "bad compresed entry at pos ~S" i)))
        do (vector-append result entry)
           (setf (gethash (make-vector-with-elt dictionary-size) dictionary)
                 (vector-append1-new w (aref entry 0)))
           (incf dictionary-size)
           (setq w entry)
        finally (return result)))

(defgeneric lzw-compress (datum)
  (:method ((string string))
    (lzw-compress (babel:string-to-octets string)))
  (:method ((octets vector))
    (lzw-compress-octets octets)))

(defun lzw-decompress-to-string (octets)
  (babel:octets-to-string (lzw-decompress octets)))

(defun test (string)
  (assert (equal #2=(lzw-decompress-to-string (lzw-compress string)) string) ()
          "Can't compress ~S properly, got ~S instead" string #2#)
  t)
