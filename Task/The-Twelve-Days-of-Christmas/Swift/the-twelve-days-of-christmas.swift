let gifts = [ "partridge in a pear tree", "Two turtle doves",
              "Three French hens",        "Four calling birds",
              "Five gold rings",          "Six geese a-laying",
              "Seven swans a-swimming",   "Eight maids a-milking",
              "Nine ladies dancing",      "Ten lords a-leaping",
              "Eleven pipers piping",     "Twelve drummers drumming" ]

let nth = [ "first",   "second", "third", "fourth", "fifth",    "sixth",
            "seventh", "eighth", "ninth", "tenth",  "eleventh", "twelfth" ]

func giftsForDay(day: Int) -> String {
  var result = "On the \(nth[day-1]) day of Christmas, my true love sent to me:\n"
  if day > 1 {
    for again in 1...day-1 {
      let n = day - again
      result += gifts[n]
      if n > 1 { result += "," }
      result += "\n"
    }
    result += "And a "
  } else {
    result += "A "
  }
  return result + gifts[0] + ".\n";
}

for day in 1...12 {
  print(giftsForDay(day))
}
