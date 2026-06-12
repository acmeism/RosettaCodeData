(seed (in "/dev/urandom" (rd 8)))
(out "image.pbm"
   (prinl "P1")
   (prinl 500 " " 500)
   (do 500
      (do 500
         (prin (if (rand T) 1 0)) )
      (prinl) ) )
