(de a (K X1 X2 X3 X4 X5)
   (let (@K (cons K)  B (cons))  # Explicit frame
      (set B
         (curry (@K B X1 X2 X3 X4) ()
            (a (dec @K) (car B) X1 X2 X3 X4) ) )
      (if (gt0 (car @K)) ((car B)) (+ (X4) (X5))) ) )

(a 10 '(() 1) '(() -1) '(() -1) '(() 1) '(() 0))
