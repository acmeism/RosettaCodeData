import parseutils

proc isNumeric(s: string): bool =
  var x: float
  s.parseFloat(x) == s.len

const Strings = ["1", "3.14", "-100", "1e2", "Inf", "rose"]

for s in Strings:
  echo s, " is ", if s.isNumeric(): "" else: "not ", "numeric"
