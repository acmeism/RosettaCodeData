(de foo @
   (bind (rest)  # Bind symbols in CARs to values in CDRs
      (println 'Bar 'is Bar)
      (println 'Mumble 'is Mumble) ) )

(foo '(Bar . 123) '(Mumble . "def"))
