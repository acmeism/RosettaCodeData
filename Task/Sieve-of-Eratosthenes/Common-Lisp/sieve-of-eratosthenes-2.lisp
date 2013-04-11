(defun sieve-odds (maximum) "sieve for odd numbers"
  (cons 2
        (let ((maxi (ash (1- maximum) -1)) (stop (ash (isqrt maximum) -1)))
          (let ((sieve (make-array (1+ maxi) :element-type 'bit :initial-element 0)))
            (loop for i from 1 to maxi
              when (zerop (sbit sieve i))
              collect (1+ (ash i 1))
              and when (<= i stop) do
                (loop for j from (ash (* i (1+ i)) 1) to maxi by (1+ (ash i 1))
                   do (setf (sbit sieve j) 1)))))))
