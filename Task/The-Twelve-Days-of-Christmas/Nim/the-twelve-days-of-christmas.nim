import strutils, algorithm

const
  gifts = """A partridge in a pear tree.
Two turtle doves
Three french hens
Four calling birds
Five golden rings
Six geese a-laying
Seven swans a-swimming
Eight maids a-milking
Nine ladies dancing
Ten lords a-leaping
Eleven pipers piping
Twelve drummers drumming""".splitLines()

  days = "first second third fourth fifth sixth seventh eighth ninth tenth eleventh twelfth".split(' ')

for n, day in days:
  var g = (gifts[0..n])
  reverse(g)
  echo "\nOn the ", day, " day of Christmas\nMy true love gave to me:\n" &
    g[0 .. -2].join("\n") &
    (if n > 0: " and\n" & g[g.high] else: capitalize(g[g.high]))
