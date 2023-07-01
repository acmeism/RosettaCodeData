instance Eq Foo where
   (Foo x1 str1) == (Foo x2 str2) =
      (x1 == x2) && (str1 == str2)
