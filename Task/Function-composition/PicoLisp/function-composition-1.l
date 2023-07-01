(de compose (F G)
   (curry (F G) (X)
      (F (G X)) ) )
