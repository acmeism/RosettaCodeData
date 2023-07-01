let
  ((gifts '("A partridge in a pear tree." "Two turtle doves, and"
            "Three French hens,"          "Four calling birds,"
            "Five gold rings,"            "Six geese a-laying,"
            "Seven swans a-swimming,"     "Eight maids a-milking,"
            "Nine ladies dancing,"        "Ten lords a-leaping,"
            "Eleven pipers piping,"       "Twelve drummers drumming," )))

   (loop for day from 1 to 12 doing
     (format t "On the ~:r day of Christmas, my true love sent to me:~%" day)
     (loop for gift from (1- day) downto 0 doing
        (format t "~a~%" (nth gift gifts)))
     (format t "~%")))
