print ["Original:"  original: "Hello,How,Are,You,Today"]
tokens: parse original ","
dotted: ""  repeat i tokens [append dotted rejoin [i "."]]
print ["Dotted:  "  dotted]
