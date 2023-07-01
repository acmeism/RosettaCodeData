import streams

proc tokenize(s: Stream, sep: static[char] = '|', esc: static[char] = '^'): seq[string] =
  var buff = ""
  while not s.atEnd():
    let c = s.readChar
    case c
    of sep:
      result.add buff
      buff = ""
    of esc:
      buff.add s.readChar
    else:
      buff.add c
  result.add buff

for i, s in tokenize(newStringStream "one^|uno||three^^^^|four^^^|^cuatro|"):
    echo i, ":", s
