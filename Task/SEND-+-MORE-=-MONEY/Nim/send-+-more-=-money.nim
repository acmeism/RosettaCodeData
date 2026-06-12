import std/strformat

let m = 1
for s in 8..9:
  for e in 0..9:
    if e in [m, s]: continue
    for n in 0..9:
      if n in [m, s, e]: continue
      for d in 0..9:
        if d in [m, s, e, n]: continue
        for o in 0..9:
          if o in [m, s, e, n, d]: continue
          for r in 0..9:
            if r in [m, s, e, n, d, o]: continue
            for y in 0..9:
              if y in [m, s, e, n, d, o]: continue
              if 1000 * s + 100 * e + 10 * n + d + 1000 * m + 100 * o + 10 * r + e ==
                 10000 * m + 1000 * o + 100 * n + 10 * e + y:
                echo &"{s}{e}{n}{d} + {m}{o}{r}{e} = {m}{o}{n}{e}{y}"
