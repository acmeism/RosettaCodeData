fconfigure stdout -encoding utf-8; #So that Unicode string will print correctly
set s1 "hello, world"
set s2 "\u304A\u306F\u3088\u3046"
puts [format "length of \"%s\" in characters is %d"  $s1 [string length $s1]]
puts [format "length of \"%s\" in characters is %d"  $s2 [string length $s2]]
