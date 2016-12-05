import strutils

var fr = "Goodbye London!"
var to = "Hello, New York!"

for fn in ["a.txt", "b.txt", "c.txt"]:
  fn.writeFile fn.readFile.replace(fr, to)
