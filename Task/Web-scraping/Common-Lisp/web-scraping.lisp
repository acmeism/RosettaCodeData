BOA> (let* ((url "http://tycho.usno.navy.mil/cgi-bin/timer.pl")
            (regexp (load-time-value
                     (cl-ppcre:create-scanner "(?m)^.{4}(.+? UTC)")))
            (data (drakma:http-request url)))
       (multiple-value-bind (start end start-regs end-regs)
           (cl-ppcre:scan regexp data)
         (declare (ignore end))
         (when start
           (subseq data (aref start-regs 0) (aref end-regs 0)))))
"Aug. 12, 04:29:51 UTC"
