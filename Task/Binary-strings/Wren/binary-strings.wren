// create string
var s = "abc"

// destroy string (not really see notes above)
s = null

// (re)assignment
s = "def"

// comparison (only == && != supported directly)
var b = (s == "abc")  // false

// cloning/copying
var t = s

// check if empty
s = ""
b = (s != "")  // false
b = s.isEmpty  // true

// append a byte
s = s + "b"

// extract a substring
s = "ghijkl"
t = s[1..4]   // "hijk"

// replace a byte or string
s = "abracadabra"
s = s.replace("a", "z")  // "zbrzczdzbrz"

// join strings
s = "abc"
t = "def"
var u = s + t  // "abcdef"
