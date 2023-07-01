#!/usr/local/bin/a68g --script #

FORMAT f = $g": ["g"]"l$;

printf((f,
  "pi", pi,
  "random", random, # actually a procedure #

  "flip", flip,
  "flop", flop,
  "TRUE", TRUE,
  "FALSE", FALSE,

  "error char", error char,
  "null character", null character,
CO   "NIL", NIL, NIL is not printable END CO

# "lengths" details how many distinctive precisions are permitted. #
# e.g. int length = 3 suggests 3 distincts types: #
#      INT, LONG INT, and LONG LONG INT #
  "bits shorths", bits shorths,
  "bits lengths", bits lengths,
  "bytes shorths", bytes shorths,
  "bytes lengths", bytes lengths,
  "int shorths", int shorths,
  "int lengths", int lengths,
  "real shorths", real shorths,
  "real lengths", real lengths,

  "max abs char", max abs char,
# short/long int/real also possible #
  "max int", max int,
  "small real", small real,
  "max real", max real,

# "width" indicates how many characters are require to prepresent the value #
# short/long bits/bytes/int/real also possible #
  "bits width", bits width,
  "bytes width", bytes width,
  "int width", int width,
  "real width", real width,
  "exp width", exp width
));

# ALL the following are actually procedures #
print((
  "space: [", space, "]", new line,
  "new line: [", new line, "]", new line,
  "new page: [", new page, "]", new line
CO the following are standard, but not implemented in algol68g
  "char number: [", char number, "]", new line,
  "line number: [", line number, "]", new line,
  "page number: [", page number, "]", new line
END CO
));
SKIP
