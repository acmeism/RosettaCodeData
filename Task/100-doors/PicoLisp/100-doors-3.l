(let Doors (need 100)
   (for I (sqrt 100)
      (set (nth Doors (* I I)) T) )
   (make
      (for (N . D) Doors
         (when D (link N)) ) ) )
