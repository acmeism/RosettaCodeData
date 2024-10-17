(call/cc
 (lambda (break)
   (let loop ((first (random 20)))
     (print first)
     (if (= first 10)
         (break))
     (print (random 20))
     (loop (random 20)))))
