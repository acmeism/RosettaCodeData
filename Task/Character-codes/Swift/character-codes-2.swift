let s1 = "a"
for c in s1.unicodeScalars {
  println(c.value) // prints "97"
}
let s2 = "π"
for c in s2.unicodeScalars {
  println(c.value) // prints "960"
}
