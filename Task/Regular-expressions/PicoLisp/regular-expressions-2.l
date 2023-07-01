(let String "The number <7> is incremented"
   (use (@A @N @Z)
      (and
         (match '(@A "<" @N ">"  @Z) (chop String))
         (format @N)
         (prinl @A "<" (inc @) ">" @Z) ) ) )
