(de days
   first second third fourth fifth sixth
   seventh eight ninth tenth eleventh twelfth )

(de texts
   "A partridge in a pear tree."
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
   "Twelve drummers drumming" )

(for (X . Day) days
   (prinl "On the " Day " day of Christmas")
   (prinl "My true love game to me:")
   (for (Y X (gt0 Y) (dec Y))
      (prinl
         (if (and (= 12 X) (= 1 Y))
            "And a partridge in a pear tree."
            (get texts Y)) ) )
   (prinl) )

(bye)
