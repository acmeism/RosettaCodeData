var messages = @["", "Fizz", "Buzz", "FizzBuzz"]
var acc = 810092048
for i in 1..100:
  var c = acc and 3
  echo(if c == 0: $i else: messages[c])
  acc = acc shr 2 or c shl 28
