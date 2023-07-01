import strutils

let oRange = 1..10
var iRange = oRange

echo """Think of a number between $# and $# and wait for me to guess it.
On every guess of mine you should state whether the guess was
too high, too low, or equal to your number by typing h, l, or =""".format(iRange.a, iRange.b)

var i = 0
while true:
  inc i
  let guess = (iRange.a + iRange.b) div 2
  stdout.write "Guess $# is: $#. The score for which is (h,l,=): ".format(i, guess)
  let txt = stdin.readLine()

  case txt
  of "h": iRange.b = guess - 1
  of "l": iRange.a = guess + 1
  of "=":
    echo "  Ye-Haw!!"
    break
  else: echo "  I don't understand your input of '%s'?".format(txt)

  if iRange.a > iRange.b or iRange.a < oRange.a or iRange.b > oRange.b:
    echo "Please check your scoring as I cannot find the value"
    break

echo "Thanks for keeping score."
