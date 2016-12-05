(let
   ((names '(first second third fourth fifth sixth seventh eighth ninth tenth eleventh twelfth))
    (gifts '( "A partridge in a pear tree." "Two turtle doves and"    "Three French hens,"
              "Four calling birds,"         "Five gold rings,"        "Six geese a-laying,"
              "Seven swans a-swimming,"     "Eight maids a-milking,"  "Nine ladies dancing,"
              "Ten lords a-leaping,"        "Eleven pipers piping,"   "Twelve drummers drumming," )))

   (loop for day in names for i from 0 doing
     (format t "On the ~a day of Christmas, my true love sent to me:" (string-downcase day))
     (loop for g from i downto 0 doing (format t "~a~%" (nth g gifts)))
     (format t "~%~%")))
