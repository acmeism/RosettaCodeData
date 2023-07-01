import strutils

let fr = "Goodbye London!"
let to = "Hello, New York!"

for fn in ["a.txt", "b.txt", "c.txt"]:
  fn.writeFile fn.readFile.replace(fr, to)
