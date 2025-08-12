# Solution for https://rosettacode.org/wiki/Arbitrary-precision_integers_(included)
import bigints
import std/math

var x = 5.initBigInt.pow 4 ^ (3 ^ 2)
var s = $x

echo s[0..19]
echo s[s.high - 19 .. s.high]
echo s.len
