BEGIN
  []STRING labels = ("first", "second", "third",    "fourth",
                     "fifth", "sixth",  "seventh",  "eighth",
                     "ninth", "tenth",  "eleventh", "twelfth");

  []STRING gifts = ("A partridge in a pear tree.",
                    "Two turtle doves, and",
                    "Three French hens,",
                    "Four calling birds,",
                    "Five gold rings,",
                    "Six geese a-laying,",
                    "Seven swans a-swimming,",
                    "Eight maids a-milking,",
                    "Nine ladies dancing,",
                    "Ten lords a-leaping,",
                    "Eleven pipers piping,",
                    "Twelve drummers drumming,");
  FOR day TO 12 DO
    print(("On the ", labels[day],
           " day of Christmas, my true love sent to me:", newline));
    FOR gift FROM day BY -1 TO 1 DO
      print((gifts[gift], newline))
    OD;
    print(newline)
  OD
END
