import sugar, strutils

proc amb(comp: proc(a, b: string): bool,
         options: seq[seq[string]],
         prev: string = ""): seq[string] =

  if options.len == 0: return @[]

  for opt in options[0]:
    # If this is the base call, prev is nil and we need to continue.
    if prev.len != 0 and not comp(prev, opt): continue

    # Take care of the case where we have no options left.
    if options.len == 1: return @[opt]

    # Traverse into the tree.
    let res = amb(comp, options[1..options.high], opt)

    # If it was a failure, try the next one.
    if res.len > 0: return opt & res    # We have a match.

  return @[]

const sets = @[@["the", "that", "a"],
               @["frog", "elephant", "thing"],
               @["walked", "treaded", "grows"],
               @["slowly", "quickly"]]

let result = amb((s, t: string) => (s[s.high] == t[0]), sets)
if result.len == 0:
  echo "No matches found!"
else:
  echo result.join " "
