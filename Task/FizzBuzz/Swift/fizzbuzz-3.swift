import Foundation

let formats: [String] = [
  "%d",
  "%d",
  "fizz",
  "%d",
  "buzz",
  "fizz",
  "%d",
  "%d",
  "fizz",
  "buzz",
  "%d",
  "fizz",
  "%d",
  "%d",
  "fizzbuzz",
]

var count = 0
var index = 0
while count < 100 {
  count += 1
  print(String(format: formats[index], count))
  index += 1
  index %= 15
}
