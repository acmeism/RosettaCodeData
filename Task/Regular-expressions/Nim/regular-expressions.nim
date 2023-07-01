import re

var s = "This is a string"

if s.find(re"string$") > -1:
  echo "Ends with string."

s = s.replace(re"\ a\ ", " another ")
echo s
