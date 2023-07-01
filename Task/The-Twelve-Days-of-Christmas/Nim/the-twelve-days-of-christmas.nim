import strutils, algorithm

const
  Gifts = ["A partridge in a pear tree.",
           "Two turtle doves",
           "Three french hens",
           "Four calling birds",
           "Five golden rings",
           "Six geese a-laying",
           "Seven swans a-swimming",
           "Eight maids a-milking",
           "Nine ladies dancing",
           "Ten lords a-leaping",
           "Eleven pipers piping",
           "Twelve drummers drumming"]

  Days = ["first", "second", "third", "fourth", "fifth", "sixth",
          "seventh", "eighth", "ninth", "tenth", "eleventh", "twelfth"]

for n, day in Days:
  var g = reversed(Gifts[0..n])
  echo "\nOn the ", day, " day of Christmas\nMy true love gave to me:\n",
       g[0..^2].join("\n"), if n > 0: " and\n" & g[^1] else: capitalizeAscii(g[^1])
