(define witt
   "                 The limits of my world are the limits of my langage.         ")
(string->html (string-trim witt))
   → "The limits of my world are the limits of my langage."
(string->html (string-trim-left witt))
   → "The limits of my world are the limits of my langage.         "
(string->html (string-trim-right witt))
   → "                 The limits of my world are the limits of my langage."
