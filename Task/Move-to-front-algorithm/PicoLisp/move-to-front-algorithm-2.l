(test (1 17 15 0 0 5)
   (encode "broood") )
(test "broood"
   (decode (1 17 15 0 0 5)) )

(test (1 1 13 1 1 1 0 0)
   (encode "bananaaa") )
(test "bananaaa"
   (decode (1 1 13 1 1 1 0 0)) )

(test (7 8 15 2 15 2 2 3 2 2 3 2)
   (encode "hiphophiphop") )
(test "hiphophiphop"
   (decode (7 8 15 2 15 2 2 3 2 2 3 2)) )
