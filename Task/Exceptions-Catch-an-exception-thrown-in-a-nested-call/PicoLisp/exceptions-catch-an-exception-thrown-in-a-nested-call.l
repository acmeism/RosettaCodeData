(de foo ()
   (for Tag '(U0 U1)
      (catch 'U0
         (bar Tag) ) ) )

(de bar (Tag)
   (baz Tag) )

(de baz (Tag)
   (throw Tag) )

(mapc trace '(foo bar baz))
(foo)
