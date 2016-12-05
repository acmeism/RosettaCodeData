import rdstdin, strutils
var a = parseInt(readLineFromStdin "Enter value of a: ")
var b = parseInt(readLineFromStdin "Enter value of b: ")

if a < b:
  echo "a is less than b"
elif a > b:
  echo "a is greater than b"
elif a == b:
  echo "a is equal to b"
