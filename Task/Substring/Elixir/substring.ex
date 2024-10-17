s = "abcdefgh"
String.slice(s, 2, 3)           #=> "cde"
String.slice(s, 1..3)           #=> "bcd"
String.slice(s, -3, 2)          #=> "fg"
String.slice(s, 3..-1)          #=> "defgh"

# UTF-8
s = "αβγδεζηθ"
String.slice(s, 2, 3)           #=> "γδε"
String.slice(s, 1..3)           #=> "βγδ"
String.slice(s, -3, 2)          #=> "ζη"
String.slice(s, 3..-1)          #=> "δεζηθ"
