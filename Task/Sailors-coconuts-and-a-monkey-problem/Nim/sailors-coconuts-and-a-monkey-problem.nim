import strformat

var coconuts = 11

for ns in 2..9:
  var hidden = newSeq[int](ns)
  coconuts = (coconuts div ns) * ns + 1
  block Search:
    while true:
      var nc = coconuts
      for sailor in 1..ns:
        if nc mod ns == 1:
          hidden[sailor-1] = nc div ns
          dec nc, hidden[sailor-1] + 1
          if sailor == ns and nc mod ns == 0:
            echo &"{ns} sailors require a minimum of {coconuts} coconuts."
            for t in 1..ns:
              echo &"\tSailor {t} hides {hidden[t-1]}."
            echo &"\tThe monkey gets {ns}."
            echo &"\tFinally, each sailor takes {nc div ns}.\n"
            break Search # Done. Continue with more sailors or exit.
        else:
          break   # Failed. Continue search with more coconuts.
      inc coconuts, ns
