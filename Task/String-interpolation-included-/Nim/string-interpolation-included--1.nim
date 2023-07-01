import strutils

var str = "little"
echo "Mary had a $# lamb".format(str)
echo "Mary had a $# lamb" % [str]
# Note: doesn't need an array for a single substitution, but uses an array for multiple substitutions.
