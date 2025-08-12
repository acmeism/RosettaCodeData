startsWith("foobar", "foo")
startsWith("barbaz", "bax")
grepl("bar", "foobarqux") #Note order of arguments isn't always the same
grepl("baz", "foobarqux")
endsWith("foobar", "bar")
endsWith("foobar", "baz")

regexpr("bar", "barbazbarbax") #Only returns position of first match

regexpr("foo", "barbazbarbax") #Returns -1 if no match exists

gregexpr("bar", "barbazbarbax") #Returns positions of all matches

gregexpr("foo", "barbazbarbax") #Same output as regexpr() if no match, but as a length-1 list rather than a vector
