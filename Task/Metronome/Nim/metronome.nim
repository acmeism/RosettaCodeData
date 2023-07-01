import os

proc metronome(tempo, pattern: Positive) =
  let delay = 60_000 div tempo    # In milliseconds.
  var beats = 0
  while true:
    stdout.write if beats mod pattern == 0: "\nTICK" else: " tick"
    stdout.flushFile
    inc beats
    sleep(delay)

metronome(72, 4)
