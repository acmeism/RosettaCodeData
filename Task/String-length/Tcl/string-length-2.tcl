set s1 "hello, world"
set s2 "\u304A\u306F\u3088\u3046"
set enc utf-8
puts [format "length of \"%s\" in bytes is %d" \
     $s1 [string length [encoding convertto $enc $s1]]]
puts [format "length of \"%s\" in bytes is %d" \
     $s2 [string length [encoding convertto $enc $s2]]]
