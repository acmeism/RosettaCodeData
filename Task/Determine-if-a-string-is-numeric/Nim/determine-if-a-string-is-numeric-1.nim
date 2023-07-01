import strutils

proc isNumeric(s: string): bool =
  try:
    discard s.parseFloat()
    result = true
  except ValueError:
    result = false

const Strings = ["1", "3.14", "-100", "1e2", "Inf", "rose"]

for s in Strings:
  echo s, " is ", if s.isNumeric(): "" else: "not ", "numeric"
