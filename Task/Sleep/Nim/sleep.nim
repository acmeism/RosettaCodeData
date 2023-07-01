import os, strutils

echo "Enter how long I should sleep (in milliseconds):"
var timed = stdin.readLine.parseInt()
echo "Sleeping..."
sleep timed
echo "Awake!"
