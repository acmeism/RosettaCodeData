scala> def rot13(s: String) = s map {
     |   case c if 'a' <= c.toLower && c.toLower <= 'm' => c + 13 toChar
     |   case c if 'n' <= c.toLower && c.toLower <= 'z' => c - 13 toChar
     |   case c => c
     | }
rot13: (s: String)String

scala> rot13("7 Cities of Gold.")
res61: String = 7 Pvgvrf bs Tbyq.

scala> rot13(res61)
res62: String = 7 Cities of Gold.
