(define (status door-num)
    (let ((x (int (sqrt door-num))))
     (if
       (= (* x x) door-num) (string "Door " door-num " Open")
       (string "Door " door-num " Closed"))))

(dolist (n (map status (sequence 1 100)))
  (println n))
