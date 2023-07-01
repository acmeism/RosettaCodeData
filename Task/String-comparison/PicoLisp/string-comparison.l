(setq
   str= =
   str< <
   str> > )

(println
   (str= (lowc "Foo") (lowc "foo") (lowc "fOO"))
   (str= "f" "foo")
   (str= "foo" "foo" "foo")
   (str= "" "") )

(println
   (str< "abc" "def")
   (str> "abc" "def")
   (str< "" "")
   (str< "12" "45") )

(bye)
