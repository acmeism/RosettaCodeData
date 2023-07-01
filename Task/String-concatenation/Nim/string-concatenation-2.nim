import strutils
var str = "String"
echo join([str, " literal.", "HelloWorld!"], "~~")

# -> String~~ literal.~~HelloWorld!
