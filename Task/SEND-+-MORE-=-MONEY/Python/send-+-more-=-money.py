# SEND + MORE = MONEY by xing216
m = 1
for s in range(8,10):
  for e in range(10):
    if e in [m, s]: continue
    for n in range(10):
      if n in [m, s, e]: continue
      for d in range(10):
        if d in [m, s, e, n]: continue
        for o in range(10):
          if o in [m, s, e, n, d]: continue
          for r in range(10):
            if r in [m, s, e, n, d, o]: continue
            for y in range(10):
              if y in [m, s, e, n, d, o]: continue
              if 1000 * s + 100 * e + 10 * n + d + 1000 * m + 100 * o + 10 * r + e == \
                 10000 * m + 1000 * o + 100 * n + 10 * e + y:
                print(f"{s}{e}{n}{d} + {m}{o}{r}{e} = {m}{o}{n}{e}{y}")
