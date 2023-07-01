from strutils import format

var verse = """$1 bottle$3 of beer on the wall
$1 bottle$3 of beer
Take one down, pass it around
$2 bottle$4 of beer on the wall"""

proc pluralize(a: int): string =
  if a > 1 or a == 0: "s"
  else: ""

for i in countdown(99, 1):
  echo format(verse, i, i-1, pluralize(i), pluralize(i-1))
