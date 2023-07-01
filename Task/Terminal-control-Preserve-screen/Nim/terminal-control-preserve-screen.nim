import os

echo "\e[?1049h\e[H"
echo "Alternate buffer!"

for i in countdown(5, 1):
  echo "Going back in: ", i
  sleep 1000

echo "\e[?1049l"
