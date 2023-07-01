(define (rot13 str)
  (join
   (map
    (fn(c)
      (cond
       ((<= "A" (upper-case c) "M") (char (+ (char c) 13)))
       ((<= "N" (upper-case c) "Z") (char (- (char c) 13)))
       (true c)))
    (explode str))))
