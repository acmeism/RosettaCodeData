(de f (X)
   (+ (sqrt (abs X)) (* 5 X X X)) )

(trace 'f)

(in NIL
   (prin "Input 11 numbers: ")
   (for X (reverse (make (do 11 (link (read)))))
      (when (> (f X) 400)
         (prinl "TOO LARGE") ) ) )
