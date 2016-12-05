import os, unicode, future

proc nothing(): bool{.closure.} = false

proc odd(prev = nothing): bool =
  let a = stdin.readChar()
  if not isAlpha(Rune(ord(a))):
    discard prev()
    stdout.write(a)
    return a != '.'

  # delay action until later, in the shape of a closure
  proc clos(): bool =
    stdout.write(a)
    prev()

  return odd(clos)

proc even(): bool =
  while true:
    let c = stdin.readChar()
    stdout.write(c)
    if not isAlpha(Rune(ord(c))):
      return c != '.'

var e = false
while (if e: odd() else: even()):
  e = not e
