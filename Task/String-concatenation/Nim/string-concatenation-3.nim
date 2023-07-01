import strutils

var str = "String"
echo "$# $# $#" % [str, "literal.", "HelloWorld!"]
# -> String literal. HelloWorld!

# Alternate form providing automatic conversion of arguments to strings.
echo "$# $# $#".format(str, 123, "HelloWorld!")
# -> String 123 HelloWorld!
