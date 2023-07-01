import times, os, strutils

let t = epochTime()

proc handler() {.noconv.} =
  echo "Program has run for ", formatFloat(epochTime() - t, precision = 0), " seconds."
  quit 0

setControlCHook(handler)

for n in 1 ..< int64.high:
  sleep 500
  echo n
