import times, os, strutils

type EKeyboardInterrupt = object of Exception

proc handler() {.noconv.} =
  raise newException(EKeyboardInterrupt, "Keyboard Interrupt")

setControlCHook(handler)

let t = epochTime()

try:
  for n in 1 .. <int64.high:
    sleep 500
    echo n
except EKeyboardInterrupt:
  echo "Program has run for ", formatFloat(epochTime() - t, precision = 0), " seconds."
