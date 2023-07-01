import os, illwill

illwillInit(fullscreen=false)

while true:
  var key = getKey()
  case key
  of Key.None:
    echo "not received a key, I can do other stuff here"
  of Key.Escape, Key.Q:
    break
  else:
    echo "Key pressed: ", $key

  sleep(1000)
