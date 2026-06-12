import os, math, terminal

proc rocket() =
  echo "        /..\\\n        |==|\n        |  |\n        |  |\n",
       "        |  |\n       /____\\\n       |    |\n       |SATU|\n       |    |\n",
       "       |    |\n      /| |  |\\\n     / | |  | \\\n    /__|_|__|__\\\n       /_\\/_\\\n"

proc exhaust() =
  echo "       *****"

proc countDown(secs: Natural) =
  stdout.write "Countdown...T minus "
  stdout.flushFile
  for i in countdown(secs, 1):
    stdout.write i, "... "
    stdout.flushFile
    os.sleep(1000)
  stdout.write "LIFTOFF!"
  stdout.flushFile

proc engineBurn(rows: Natural) =
  echo '\n'
  for i in 1..rows:
    exhaust()
    sleep (0.9^i * 1000).toInt

proc testRocket() =
  eraseScreen()
  rocket()
  cursorUp(16)
  countDown(5)
  cursorDown(13)
  engineBurn(30)

testRocket()
