from strutils import format

for i in countdown(99, 1):
  case i
  of 3..99:
    echo format("""$1 bottles of beer on the wall
$1 bottles of beer
Take one down, pass it around
$2 bottles of beer on the wall""", i, i-1)
  of 2:
    echo format("""$1 bottles of beer on the wall
$1 bottles of beer
Take one down, pass it around
$2 bottle of beer on the wall""", i, i-1)
  of 1:
    echo format("""$1 bottle of beer on the wall
$1 bottle of beer
Take one down, pass it around
No more bottles of beer on the wall""", i)
  else:
    discard
