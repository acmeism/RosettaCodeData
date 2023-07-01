(de foo @
   (bind (next)                # Save all symbols in first argument
      (mapc set (arg) (rest))  # then bind them to remaining arguments
      (println 'Bar 'is Bar)
      (println 'Mumble 'is Mumble) ) )

(foo '(Bar Mumble) 123 "def")
