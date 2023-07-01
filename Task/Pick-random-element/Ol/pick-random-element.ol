(import (otus random!))

(define x '("Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday" "Sunday"))
(print (list-ref x (rand! (length x))))
