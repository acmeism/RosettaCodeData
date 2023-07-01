[ "one", "two", "three", "four", "five", "six",
    "seven", "eight", "nine", "ten", "eleven", "twelve"] as $cardinals
| [ "first", "second", "third", "fourth", "fifth", "sixth",
    "seventh", "eighth", "ninth", "tenth", "eleventh", "twelfth"] as $ordinals
| [ "a partridge in a pear tree.", "turtle doves", "French hens",
    "calling birds", "gold rings", "geese a-laying", "swans a-swimming",
    "maids a-milking", "ladies dancing", "lords a-leaping", "pipers piping",
    "drummers drumming" ] as $gifts
| range(12) | . as $i | $ordinals[$i] as $nth
| "On the " + $nth + " day of Christmas, my true love sent to me:\n" +
  ([[range($i+1)]|reverse[]|. as $j|$cardinals[$j] as $count|
     if $j > 0 then $count else if $i > 0 then "and" else "" end end +
      " " + $gifts[$j] + if $j > 0 then "," else "\n" end]
  | join("\n"))
