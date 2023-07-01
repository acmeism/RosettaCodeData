import os

const debug = false

proc expensive: string =
  sleep(milsecs = 100)
  result = "That was difficult"

proc log(msg: string) =
  if debug:
    echo msg

for i in 1..10:
  log expensive()
