(defun ip->bit-vector (ip)
  (flet ((int->bits (int)
           (loop :for i :below 8
                 :collect (if (logbitp i int) 1 0) :into bits
                 :finally (return (nreverse bits)))))
    (loop :repeat 4
          :with start := 0
          :for pos := (position #\. ip :start start)
          :collect (parse-integer ip :start start :end pos) :into res
          :while pos
          :do (setf start (1+ pos))
          :finally (return (apply #'concatenate 'bit-vector (mapcar #'int->bits res))))))

(defun bit-vector->ip (vec &optional n)
  (loop :repeat 4
        :for end :from 8 :by 8
        :for start := (- end 8)
        :for sub := (subseq vec start end)
        :collect (parse-integer (map 'string #'digit-char sub) :radix 2) :into res
        :finally (return (format nil "~{~D~^.~}~@[/~A~]" res n))))

(defun canonicalize-cidr (cidr)
  (let* ((n (position #\/ cidr))
         (ip (subseq cidr 0 n))
         (sn (parse-integer cidr :start (1+ n)))
         (ip* (ip->bit-vector ip))
         (canonical-ip (fill ip* 0 :start sn)))
    (bit-vector->ip canonical-ip sn)))

(loop :for cidr :in '("36.18.154.103/12" "62.62.197.11/29"
                      "67.137.119.181/4" "161.214.74.21/24"
                      "184.232.176.184/18")
      :for ccidr := (canonicalize-cidr cidr)
      :do (format t "~&~A~20,T→  ~A~%" cidr ccidr))
