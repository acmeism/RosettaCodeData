CL-USER> (number-names::test)
number => (format t "~R" number) => (parse (format t "~R" number))
0 => zero => 0
-3 => negative three => -3
5 => five => 5
-7 => negative seven => -7
11 => eleven => 11
-13 => negative thirteen => -13
17 => seventeen => 17
-19 => negative nineteen => -19
23 => twenty-three => 23
-29 => negative twenty-nine => -29
201021002001 => two hundred one billion twenty-one million two thousand one => 201021002001
-20102100201 => negative twenty billion one hundred two million one hundred thousand two hundred one => -20102100201
2010210020 => two billion ten million two hundred ten thousand twenty => 2010210020
-201021002 => negative two hundred one million twenty-one thousand two => -201021002
20102100 => twenty million one hundred two thousand one hundred => 20102100
-2010210 => negative two million ten thousand two hundred ten => -2010210
201021 => two hundred one thousand twenty-one => 201021
-20103 => negative twenty thousand one hundred three => -20103
2010 => two thousand ten => 2010
-201 => negative two hundred one => -201
20 => twenty => 20
-2 => negative two => -2
0 => zero => 0
; No value
