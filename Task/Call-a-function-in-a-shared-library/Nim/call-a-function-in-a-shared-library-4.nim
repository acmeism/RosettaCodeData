# nim c --app:lib fakeimg.nim
var handle = 100

proc openimage*(s: string): int {.exportc, dynlib.} =
  stderr.writeln "opening ", s
  result = handle
  inc(handle)
