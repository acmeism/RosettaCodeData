(def days ["first" "second" "third"
           "fourth" "fifth" "sixth"
           "seventh" "eighth" "ninth"
           "tenth" "eleventh" "twelfth"])
(def gifts ["A partridge in a pear tree."
            "Two turtle doves and"
            "Three french hens"
            "Four calling birds"
            "Five golden rings"
            "Six geese a-laying"
            "Seven swans a-swimming"
            "Eight maids a-milking"
            "Nine ladies dancing"
            "Ten lords a-leaping"
            "Eleven pipers piping"
            "Twelve drummers drumming"])
(var v "")
(eachp [i d] days
  (print "On the " d " day of Christmas")
  (print "My true love gave to me")
  (set v (string (in gifts i) "\n" v))
  (print v))
