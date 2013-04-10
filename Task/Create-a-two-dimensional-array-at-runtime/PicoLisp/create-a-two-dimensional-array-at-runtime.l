(de 2dimTest (DX DY)
   (let A (make (do DX (link (need DY))))
      (set (nth A 3 3) 999)            # Set A[3][3] to 999
      (mapc println A)                 # Print all
      (get A 3 3) ) )                  # Return A[3][3]

(2dimTest 5 5)
