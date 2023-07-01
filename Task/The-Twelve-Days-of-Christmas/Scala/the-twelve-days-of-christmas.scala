val gifts = Array(
    "A partridge in a pear tree.",
    "Two turtle doves and",
    "Three French hens,",
    "Four calling birds,",
    "Five gold rings,",
    "Six geese a-laying,",
    "Seven swans a-swimming,",
    "Eight maids a-milking,",
    "Nine ladies dancing,",
    "Ten lords a-leaping,",
    "Eleven pipers piping,",
    "Twelve drummers drumming,"
  )

val days = Array(
    "first",   "second", "third", "fourth", "fifth",    "sixth",
    "seventh", "eighth", "ninth", "tenth",  "eleventh", "twelfth"
  )

val giftsForDay = (day: Int) =>
    "On the %s day of Christmas, my true love sent to me:\n".format(days(day)) +
      gifts.take(day+1).reverse.mkString("\n") + "\n"

(0 until 12).map(giftsForDay andThen println)
