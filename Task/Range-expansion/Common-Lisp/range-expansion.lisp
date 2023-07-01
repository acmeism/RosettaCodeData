(defun expand-ranges (string)
  (loop
     with prevnum = nil
     for idx = 0 then (1+ nextidx)
     for (number nextidx) = (multiple-value-list
                             (parse-integer string
                                            :start idx :junk-allowed t))
     append (cond
              (prevnum
               (prog1
                   (loop for i from prevnum to number
                      collect i)
                 (setf prevnum nil)))
              ((and (< nextidx (length string))
                    (char= (aref string nextidx) #\-))
               (setf prevnum number)
               nil)
              (t
               (list number)))
     while (< nextidx (length string))))

CL-USER> (expand-ranges "-6,-3--1,3-5,7-11,14,15,17-20")
(-6 -3 -2 -1 3 4 5 7 8 9 10 11 14 15 17 18 19 20)
