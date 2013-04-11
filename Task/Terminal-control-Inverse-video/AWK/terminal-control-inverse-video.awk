BEGIN {
system ("tput rev")
print "foo"
system ("tput sgr0")
print "bar"
}
