import algorithm, strformat, strutils

let list = ["violet", "red", "green", "indigo", "blue", "yellow", "orange"]

var count = 0

proc comp(x, y: string): int =
  if x == y: return 0
  inc count
  while true:
    stdout.write &"{count:>2}) Is {x} less than {y} (y/n)? "
    let answer = stdin.readLine()[0]
    case answer
    of 'y': return -1
    of 'n': return 1
    else: echo "Incorrect answer."

var sortedList: seq[string]

for elem in list:
  sortedList.insert(elem, sortedList.upperBound(elem, comp))

echo "Sorted list: ", sortedList.join(", ")
