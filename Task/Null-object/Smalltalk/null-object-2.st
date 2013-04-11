foo := nil.
foo class. "-> UndefinedObject"
foo respondsTo: #'bar'. "asking if a message is implemented"

foo class compile:'fancyOperation ^ 123'.
foo fancyOperation "->123"
