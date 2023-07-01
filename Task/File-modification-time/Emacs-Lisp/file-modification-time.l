(nth 5 (file-attributes "input.txt")) ;; mod date+time

(set-file-times "input.txt") ;; to current-time
(set-file-times "input.txt"
                (encode-time 0 0 0  1 1 2014)) ;; to given date+time
