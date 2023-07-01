import std/strformat
import integers

for base in 2..16:
  stdout.write &"{base:>2}:"
  var rep = ""
  while true:
    rep.add '1'
    if rep.len > 2700: break
    if not rep.len.isPrime: continue
    let val = newInteger(rep, base)
    if val.isPrime():
      stdout.write ' ', rep.len
  echo()
