# one.awk
BEGIN {
  sayhello()
}

# two.awk
function sayhello() {
  print "Hello world"
}
