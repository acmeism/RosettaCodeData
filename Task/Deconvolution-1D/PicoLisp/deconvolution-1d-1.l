(load "@lib/math.l")

(de deconv (G F)
   (let A (pop 'F)
      (make
         (for (N . H) (head (- (length F)) G)
            (for (I . M) (made)
               (dec 'H
                  (*/ M (get F (- N I)) 1.0) ) )
            (link (*/ H 1.0 A)) ) ) ) )
