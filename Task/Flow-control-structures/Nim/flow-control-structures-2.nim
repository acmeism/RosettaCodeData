var f = open "input.txt"
try:
  var s = readLine f
except ReadIOEffect:
  echo "An error occured!"
finally:
  close f
