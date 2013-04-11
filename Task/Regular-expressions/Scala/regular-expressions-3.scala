"\\d+".r findFirstIn "99 bottles of beer" // returns first partial match, or None
"\\w+".r findAllIn "99 bottles of beer" // returns all partial matches as an iterator
"\\s+".r findPrefixOf "99 bottles of beer" // returns a matching prefix, or None
Bottles4 findFirstMatchIn "99 bottles of beer" // returns a "Match" object, or None
Bottles4 findPrefixMatchOf "99 bottles of beer" // same thing, for prefixes
val bottles = (Bottles4 findFirstMatchIn "99 bottles of beer").get.group("bottles") // Getting a group by name
val Bottles4(bottles) = "99 bottles of beer" // syntactic sugar (not using group name)
