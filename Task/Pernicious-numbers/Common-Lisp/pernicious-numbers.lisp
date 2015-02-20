(format T "~{~a ~}~%"
        (loop for n = 1 then (1+ n)
              when (primep (logcount n))
                collect n into numbers
              when (= (length numbers) 25)
                return numbers))

(format T "~{~a ~}~%"
        (loop for n from 888888877 to 888888888
              when (primep (logcount n))
                collect n))
