var f = open "input.txt"
try:
  var s = readLine f
except IOError:
  echo "An error occurred!"
finally:
  close f
