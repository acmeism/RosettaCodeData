#!/usr/local/bin/a68g --script #

printf((
  $g" => "2r3d l$, 5, BIN 5,
  $g" => "2r6d l$, 50, BIN 50,
  $g" => "2r14d l$, 9000, BIN 9000
));

# or coerce to an array of BOOL #
print((
  5, " => ", []BOOL(BIN 5)[bits width-3+1:], new line,
  50, " => ", []BOOL(BIN 50)[bits width-6+1:], new line,
  9000, " => ", []BOOL(BIN 9000)[bits width-14+1:], new line
))
