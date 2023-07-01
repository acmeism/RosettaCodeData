(print
(let loop ((i 2))
   (if (eq? (mod (* i i) 1000000) 269696)
      i
      (loop (+ i 1)))))
