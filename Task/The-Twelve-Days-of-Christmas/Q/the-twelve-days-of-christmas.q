DAYS:" "vs"first second third fourth fifth sixth",
  " seventh eighth ninth tenth eleventh twelfth"

STANZA:(                              / final stanza
  "On the twelfth day of Christmas";
  "My true love gave to me:";
  "Twelve drummers drumming";
  "Eleven pipers piping";
  "Ten lords a-leaping";
  "Nine ladies dancing";
  "Eight maids a-milking";
  "Seven swans a-swimming";
  "Six geese a-laying";
  "Five golden rings";
  "Four calling birds";
  "Three french hens";
  "Two turtle doves";
  "And a partridge in a pear tree.";
  "")

-1 raze
  .[;0 2;"A",5_]                         / tweak one line
  .[;(::;0);ssr[;"twelfth";];DAYS]       / number the verses
  STANZA 0 1,/:#\:[;til 15] -2 -til 12;  / compose 12 verses
