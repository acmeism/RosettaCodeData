CL-USER> (progn (loop repeat #1=(expt 10 6)
                      for round = (make-round)
                      for initial = (random 3)
                      for goat = (show-goat initial round)
                      for choice = (loop for i = (random 3)
                                         when (and (/= i initial)
                                                   (/= i goat))
                                           return i)
                      when (won? round (random 3))
                        sum 1 into result-stay
                      when (won? round choice)
                        sum 1 into result-switch
                      finally (progn (format t "Stay: ~S%~%" (float (/ result-stay
                                                                       #1# 1/100)))
                                     (format t "Switch: ~S%~%" (float (/ result-switch
                                                                         #1# 1/100))))))
Stay: 33.2716%
Switch: 66.6593%
